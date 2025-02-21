function(input, output, session) {
  
  output$plot1_line <- renderPlotly({
    
    # Data Wrangling
    sales_trend <- data_clean %>% 
      group_by(month) %>% 
      summarise(total_sales = sum(grand_total)) %>% 
      ungroup() %>% 
      arrange(month)
    
    # nambah kolom month singkatan & full month ~> utk x axis di plot & tooltip
    sales_trend <- sales_trend %>%
      mutate(
        # kolom singkatan utk sumbu x
        month_name = factor(month, levels = 1:12, labels = month.abb),
        # kolom full month utk tooltip
        full_month_name = factor(month, levels = 1:12, labels = month.name)
      )
    
    #buat tooltip desc
    sales_trend <- sales_trend %>% 
      mutate(
        label = glue(
          "Total Sales: {comma(total_sales)}
          Month: {full_month_name}")
      )
    
    # Visualization ~> dibuat ggplot nyaa
    #"Monthly Sales Trend in Pakistan for 2017"
    
    plot1 <- ggplot(sales_trend, aes(x=month_name, y= total_sales))+
      
      geom_line(col="darkgreen", group=1) +
      geom_point(aes(text=label), col="black") +
      scale_y_continuous(labels = comma, breaks = seq(0, 100000000, 10000000)) +
      labs(
        title = "Monthly Sales Trend",
        x = NULL,
        y = "Total Sales"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5)
      )
    
    ggplotly(plot1, tooltip = "text")
  })
  
  output$plot2_lolipop <- renderPlotly({
    
    # Data Wrangling 
    fav_payment<- data_clean %>% 
      group_by(payment_method) %>% 
      summarise(Payment_type = n()) %>% 
      ungroup() %>% 
      arrange(-Payment_type) 
    
    fav_payment <- fav_payment %>% 
      mutate(
        label = glue(
          "Payment Method: {payment_method}
      Total Orders: {comma(Payment_type)}"
        )
      )
    
    # Visualization ~> dibuat ggplot nyaa
    #"Fav Payment Method in each Category"
    plot2 <- ggplot(fav_payment, aes(x = Payment_type, 
                                     y = reorder(payment_method, Payment_type),
                                     text = label)) +
      
      geom_segment(aes(x= 0, xend=Payment_type, yend=reorder(payment_method, Payment_type)), color="darkgreen", size= 1) +
      geom_point(color="black", size=3) +
      scale_x_continuous(labels = comma) +
      labs(title = "Top Payment Method",
           x = "Total Orders",
           y = NULL) +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5)
      )
    
    ggplotly(plot2, tooltip = "text")
  })
  
  output$plot3_line <- renderPlotly({
    
    # Data Wrangling
    category_sales_trend <- data_clean %>%
      filter(category_name ==input$input_category) %>% 
      group_by(month) %>% 
      summarise(total_sales_category = sum(grand_total)) %>% 
      ungroup() %>% 
      arrange(month)
    
    # nambah kolom month singkatan & full month ~> utk x axis di plot & tooltip
    category_sales_trend <- category_sales_trend %>%
      mutate(
        # kolom singkatan utk sumbu x
        month_name = factor(month, levels = 1:12, labels = month.abb),
        # kolom full month utk tooltip
        full_month_name = factor(month, levels = 1:12, labels = month.name)
      )
    
    #buat tooltip desc
    category_sales_trend <- category_sales_trend %>% 
      mutate(
        label = glue(
          "Total Sales: {comma(total_sales_category)}
      Month: {full_month_name}"
        )
      )
    
    # Visualization ~> dibuat ggplot nyaa
    #"Monthly total sales in each category"
    
    plot3 <- ggplot(category_sales_trend, aes(x=month_name, y= total_sales_category))+
      
      geom_line(col="darkgreen", group=1) +
      geom_point(aes(text=label), col="black") +
      scale_y_continuous(labels = comma) +
      labs(
        title = glue("Monthly Sales for {input$input_category}"),
        x = NULL,
        y = "Total Sales"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5)
      )
    
    ggplotly(plot3, tooltip = "text")
  })
  
  output$plot4_bar <- renderPlotly({
    
    # Data Wrangling
    fav_product <- data_clean %>% 
      filter(category_name ==input$input_category) %>% 
      group_by(product_name) %>% 
      summarise(total_qty = sum(qty_ordered), total_sold= sum(grand_total)) %>% 
      ungroup() %>% 
      arrange(-total_qty) %>% 
      head(10)
    
    #Buat fungsi untuk mendelete description di nama produk
    process_product_name <- function(product_name) {
      parts <- str_split(product_name, " - ") %>% 
        unlist()  # dibagi berdasarkan ' - '
      if (length(parts) > 2) {
        # kalau lebih dari 2 bagian kata, yg di print hanya bagian pertama dan terakhir (nama brand & warna)
        return(paste(parts[1], parts[length(parts)], sep = " - "))
      } else {
        # kalau kurang dari sama dengan 2 bagian kata, tidak dilakukan apa apa
        return(product_name)
      }
    }
    
    fav_product<- fav_product %>% 
      mutate(short_name = sapply(product_name, process_product_name)) %>% # Truncate to 20 chars
      mutate(label = glue(
        "Product : {product_name}
      Total Sales : {comma(total_sold)}
      Quantity : {total_qty}"
      )
      )
    
    # Visualization ~> dibuat ggplot nyaa
    # "Top 10 Best Selling Product in each category"
    plot4 <- ggplot(fav_product, aes(x = total_sold,
                                     y = reorder(short_name, total_sold),
                                     text = label)) +
      
      geom_col(aes(fill = total_sold)) +
      scale_fill_gradient(low="black", high="darkgreen") +
      labs(title = glue("Top {input$input_category} Products"),
           x = "Total Sales",
           y = NULL) +
      scale_x_continuous(labels = comma) +
      theme_minimal() +
      theme(legend.position = "none", plot.title = element_text(hjust = 0.5 ))
    
    ggplotly(plot4, tooltip = "text")
  })
  
  output$plot5_bar <- renderPlotly({
    
    # Data Wrangling
    rank_qty_pcategory <- data_clean %>% 
      filter(created_at >= as.Date(input$input_date[1]) & created_at <= as.Date(input$input_date[2])) %>% 
      group_by(category_name) %>% 
      summarise(qty_pcategory = sum(qty_ordered)) %>% 
      ungroup() %>% 
      arrange(-qty_pcategory) 
    
    #buat desc tooltip
    rank_qty_pcategory <- rank_qty_pcategory %>% 
      mutate(label = glue(
        "Category : {category_name}
      Quantity : {comma(qty_pcategory)}"
      )
      )
    
    # Visualization ~> dibuat ggplot nyaa
    # Quantity Product in each category Ordered over the year 2017"
    plot5 <- ggplot(rank_qty_pcategory, aes(x = qty_pcategory,
                                            y = reorder(
                                              category_name, qty_pcategory),
                                            text = label)) +
      
      geom_col(aes(fill = qty_pcategory)) +
      scale_fill_gradient(low="black", high="darkgreen") +
      labs(title = "Top Categories by Quantity Sold",
           x = "Quantity",
           y = NULL) +
      scale_x_continuous(labels = comma) +
      theme_minimal() +
      theme(legend.position = "none", plot.title = element_text(hjust = 0.5))
    
    ggplotly(plot5, tooltip = "text")
  })
  
  output$plot6_scatter <- renderPlotly({
    
    # Data Wrangling
    rank_qty_pprice <- data_clean %>% 
      filter(created_at >= as.Date(input$input_date[1]) & created_at <= as.Date(input$input_date[2])) %>% 
      group_by(price) %>% 
      summarise(qty_pprice = sum(qty_ordered)) %>% 
      ungroup() %>% 
      arrange(-qty_pprice) 
    
    #buat desc tooltip
    rank_qty_pprice <- rank_qty_pprice %>%
      mutate(label = glue(
        "Price : {comma(price)}
      Quantity : {comma(qty_pprice)}")
      )
    
    # Visualization ~> dibuat ggplot nyaa
    # Relationship between price & quantity sold product
    plot6 <- ggplot(rank_qty_pprice, aes(x = qty_pprice,
                                         y = price,
                                         text = label)) +
      
      geom_jitter(color="darkgreen") +
      labs(title = "Relationship Between Price and Quantity Sold Products",
           x = "Quantity",
           y = "Price") +
      scale_x_continuous(labels = comma) +
      scale_y_continuous(labels = comma)+
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5)
      )
    
    ggplotly(plot6, tooltip = "text")
  })
  
  output$plot7_lolipop <- renderPlotly({
    
    # Data Wrangling
    rank_sales_cat <- data_clean %>% 
      filter(created_at >= as.Date(input$input_date[1]) & created_at <= as.Date(input$input_date[2])) %>% 
      group_by(category_name) %>% 
      summarise(sales = sum(grand_total)) %>% 
      ungroup() %>% 
      arrange(-sales) 
    
    rank_sales_cat <- rank_sales_cat %>% 
      mutate(
        label = glue(
          "Category: {category_name}
      Total Sales: {comma(sales)}"
        )
      )
    
    # Visualization ~> dibuat ggplot nyaa
    # Top categories by total sales
    plot7 <- ggplot(rank_sales_cat, aes(x = sales, 
                                        y = reorder(category_name, sales),
                                        text = label)) +
      
      geom_segment(aes(x= 0, xend=sales, yend=reorder(category_name, sales)), color="darkgreen", size= 1) +
      geom_point(color="black", size=3) +
      scale_x_continuous(labels = comma) +
      labs(title = "Top Categories by Total Sales",
           x = "Total Sales",
           y = NULL) +
      theme_minimal() +
      theme(
        plot.title = element_text(hjust = 0.5)
      )
    
    ggplotly(plot7, tooltip = "text")
  })
  
  output$dataset <- DT::renderDT(
    data_clean,
    options = list(scrollX = TRUE,  # Memungkinkan scroll horizontal
                   scrollY = TRUE)  # Memungkinkan scroll vertikal
  )
}
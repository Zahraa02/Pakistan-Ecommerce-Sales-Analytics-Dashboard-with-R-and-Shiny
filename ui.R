# UI File

# Dashboard Page
dashboardPage(
  skin = "green",
  
  # ------ Header ------ 
  dashboardHeader(title = "Pakistan Sales Trend", titleWidth = 235),

  
  
  # ----- Sidebar ------ 
  dashboardSidebar
  (
    width= 235,
    sidebarMenu
    (
      # ----- Tab 1: Dashboard ------
      menuItem("Dashboard", tabName = "page1", icon = icon("grip")),
      
      # ----- Tab 2: Sales Analysis ------
      menuItem("Sales", tabName = "page2", icon = icon("chart-line")),
      
      # ----- Tab 3: Orders ------
      menuItem("Orders", tabName = "page3", icon = icon("cube")),
      
      # ----- Tab 4: Dataset ------
      menuItem("Dataset", tabName = "page4", icon = icon("folder"))
    )
  ),
  
  
  # ----- Main / Body ------
  dashboardBody
  (
    tags$head
    (
      tags$style(HTML("
    .small-box {
      border-radius: 15px;  
      box-shadow: none;
    }
      
    h2 {
      font-size: 40px;
      font-weight: bold; 
    }
  
      "))
    ),
    
    tabItems
    (
      
      # ----- Page 1 ------
      tabItem
      (
        tabName = "page1", 
        h2("Pakistan Ecommerce Sales Trend in 2017"), 
        
        # ---- row 1 ----
        fluidRow
        (
          valueBox
          (
            width = 3, 
            number(sum(data_clean$grand_total), big.mark = '.', decimal.mark =',', accuracy = 1),
            " Total Sales",
            icon = icon("money-bill-trend-up"),
            color = "olive"
          ),
          
          valueBox
          (
            width = 3, 
            number(nrow(data_clean),  big.mark = '.', decimal.mark =',', accuracy = 1),
            " Total Transaction",
            icon = icon("arrow-right-arrow-left"),
            color = "yellow"
          ),
          
          valueBox
          (
            width = 3, 
            number(sum(data_clean$qty_ordered),  big.mark = '.', decimal.mark =',', accuracy = 1),
            " Total Products",
            icon = icon("box"),
            color = "red"
          ),
          
          valueBox
          (
            width = 3,
            number(length(unique(data_clean$Customer.ID)),  big.mark = '.', decimal.mark =',', accuracy = 1),
            " Total Customer",
            icon = icon("user"),
            color = "light-blue"
          ) 
        ),
        
        # ---- row 2 ---- 
        fluidRow
        (
          box
          (
            width = 12, 
            plotlyOutput(outputId = "plot1_line") 
          )
        ),
        
        # ---- row 3 ---- 
        fluidRow
        (
          box
          (
            width = 12, 
            plotlyOutput(outputId = "plot2_lolipop") 
          )
        )
      
      ), # End of tabItem (page 1)
      
      
      # ----- Page 2 ------
      tabItem
      (
        tabName = "page2",
        h2("Monthly Sales Trend and Top Products"), 
        
        # ---- row 1 ----
        fluidRow
        (
          box
          (
            width = 12, 
            selectInput
            (
              inputId= "input_category", 
              label= "Choose product category", 
              choices= unique(data_clean$category_name), 
              selected = "Beauty & Grooming" 
            )
          )
        ),
        
        # ---- row 2 ---- 
        fluidRow
        (
          box
          (
            width = 12, 
            plotlyOutput(outputId = "plot3_line") 
          )
        ),
        
        # ---- row 3 ---- 
        fluidRow
        (
          box
          (
            width = 12, 
            plotlyOutput(outputId = "plot4_bar") 
          ) 
        )
        
      ), # End of tabItem (page 2)
      
      
      # ----- Page 3 ------
      tabItem
      (
        tabName = "page3",
        h2("Order Analysis: Sales, Quantity, and Pricing Relationships "),
        
        # ---- row 1 ----
        fluidRow
        (
          box
          (
            width = 12, 
            dateRangeInput
            (
              inputId= "input_date", 
              label= "Choose the date", 
              start= "2017-01-01", 
              end= "2017-12-31", 
              min= "2017-01-01", 
              max= "2017-12-31", 
              separator= "to" 
            )
          )
        ),
        
        # ---- row 2 ---- 
        fluidRow
        (
          box
          (
            width = 12, 
            plotlyOutput(outputId = "plot7_lolipop") 
          )
        ),
        
        # ---- row 3 ---- 
        fluidRow
        (
          box
          (
            width = 6, 
            plotlyOutput(outputId = "plot5_bar") 
          ),
          box
          (
            width = 6,
            plotlyOutput(outputId = "plot6_scatter") 
          )
        )
      ),  # End of tabItem (page 3)
      
      
      # ----- Page 4 ------
      tabItem
      (
        tabName = "page4",
        h2("Dataset"),
        
        # ---- row 1 ----
        fluidRow
        (
          box(
            width = 12,
            title = "Pakistan Ecommerce Data in 2017",
            DT::DTOutput(outputId="dataset")
          )
        )
      ) # End of tabItem (page 4)
      
    ) # End of tabItems 
  ) #End of dashboardBody
  
) # End of dashboardPage



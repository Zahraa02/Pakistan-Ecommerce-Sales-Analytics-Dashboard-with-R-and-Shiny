#filee utk tampilaan UI nyaa


#step 1: buat bagiaan di dashboard page
dashboardPage(
  # Warna (skin color)
  skin = "green",
  
  # ------ Bagian Header ------ (ex. menampilkan judul/ ikon navigasi (menu atau notifikasi))
  dashboardHeader(title = "Pakistan Sales Trend", titleWidth = 235),  #step 2: Menambahkan judul di pojok kiri atas pada header

  
  
  # ----- Bagian Sidebar ------ (ex.menempatkan elemen-elemen navigasi (menu utk berpindah antar halaman/ memilih berbagai opsi filter))
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
  
  
  # ----- Bagian Main / Body ------ (ex. konten inti seperti grafik, tabel, dan visualisasi lain ditampilkan)
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
        #assign & namaa tab awal
        tabName = "page1", 
        h2("Pakistan Ecommerce Sales Trend in 2017"), #utk ngasii titlee di pagenyaa
        
        # ---- #utk assign baris 1 ----
        fluidRow
        (
          #utk ngasii box pertamaa visualisasi 
          valueBox
          (
            width = 3, #Lebar kotak 3 dari total 12 kolom (emg default shiny itu range satuanya dr 0-12)
            comma(sum(data_clean$grand_total)),
            " Total Sales",
            icon = icon("money-bill-trend-up"),
            color = "olive"
          ),
          
          #utk ngasii box keduaa 
          valueBox
          (
            width = 3, #Lebar kotak 3 
            comma(nrow(data_clean)),
            " Total Transaction",
            icon = icon("arrow-right-arrow-left"),
            color = "yellow"
          ),
          
          #utk ngasii box ketiga 
          valueBox
          (
            width = 3, #Lebar kotak 3 
            comma(sum(data_clean$qty_ordered)),
            " Total Products",
            icon = icon("box"),
            color = "red"
          ),
          
          #utk ngasii box keempat 
          valueBox
          (
            width = 3, #Lebar kotak 3 
            comma(length(unique(data_clean$Customer.ID))),
            " Total Customer",
            icon = icon("user"),
            color = "light-blue"
          ) 
        ),
        
        # ---- #utk assign baris 2 ---- 
        fluidRow
        (
          #utk ngasii box di baris keduaa 
          box
          (
            width = 12, #Lebar kotak seluruh bariis
            plotlyOutput(outputId = "plot1_line") #krn kita dr ggplot maka funct (plotlyOutput())
          )
        ),
        
        # ---- #utk assign baris 3 ---- 
        fluidRow
        (
          #utk ngasii box di baris ketiga 
          box
          (
            width = 12, #Lebar kotak seluruh bariis
            plotlyOutput(outputId = "plot2_lolipop") #krn kita dr ggplot maka funct (plotlyOutput())
          )
        )
      
      ), # End of tabItem (page 1)
      
      
      # ----- Page 2 ------
      tabItem
      (
        #assign & namaa tab keduaa
        tabName = "page2",
        h2("Monthly Sales Trend and Top Products"), #utk ngasii titlee di pagenyaa
        
        # ---- #utk assign baris 1 ----
        fluidRow
        (
          #utk ngasii satu box input 
          box
          (
            width = 12, #Lebar kotak 
            selectInput
            (
              inputId= "input_category", 
              label= "Choose product category", #Label/ judul utk input
              choices= unique(data_clean$category_name), #Daftar pilihan diambil dari kategori
              selected = "Beauty & Grooming" #Pilihan default
            )
          )
        ),
        
        # ---- #utk assign baris 2 ---- 
        fluidRow
        (
          #utk ngasii 1 box di baris keduaa 
          box
          (
            width = 12, #Lebar kotak seluruh bariis
            plotlyOutput(outputId = "plot3_line") #krn kita dr ggplot maka funct (plotlyOutput())
          )
        ),
        
        # ---- #utk assign baris 3 ---- 
        fluidRow
        (
          #utk ngasii 1 box di baris ketigaa 
          box
          (
            width = 12, #Lebar kotak seluruh bariis
            plotlyOutput(outputId = "plot4_bar") #krn kita dr ggplot maka funct (plotlyOutput())
          ) 
        )
        
      ), # End of tabItem (page 2)
      
      
      # ----- Page 3 ------
      tabItem
      (
        #assign & namaa tab keduaa
        tabName = "page3",
        h2("Order Analysis: Sales, Quantity, and Pricing Relationships "), #utk ngasii titlee di pagenyaa
        
        # ---- #utk assign baris 1 ----
        fluidRow
        (
          #utk ngasii satu box input 
          box
          (
            width = 12, #Lebar kotak sebaris utk input dropdown
            dateRangeInput
            (
              inputId= "input_date", 
              label= "Choose the date", #Label/ judul utk input
              start= "2017-01-01", #tampilan start date yg mau kita kasii
              end= "2017-12-31", #tampilan end date yang mau kita kasi
              min= "2017-01-01", #option paling minimal yang bisa dipilih
              max= "2017-12-31", #option paling maksimal yang bisa dipilih
              separator= "to" #text diantara start date & end date
            )
          )
        ),
        
        # ---- #utk assign baris 2 ---- 
        fluidRow
        (
          box
          (
            width = 12, # lebar box
            plotlyOutput(outputId = "plot7_lolipop") 
          )
        ),
        
        # ---- #utk assign baris 3 ---- 
        fluidRow
        (
          #utk ngasii 1 box di baris keduaa 
          box
          (
            width = 6, #Lebar box
            plotlyOutput(outputId = "plot5_bar") #krn kita dr ggplot maka funct (plotlyOutput())
          ),
          box
          (
            width = 6, #Lebar box
            plotlyOutput(outputId = "plot6_scatter") #krn kita dr ggplot maka funct (plotlyOutput())
          )
        )
      ),  # End of tabItem (page 3)
      
      
      # ----- Page 4 ------
      tabItem
      (
        #assign & namaa tab keduaa
        tabName = "page4",
        h2("Dataset"), #utk ngasii titlee di pagenyaa
        
        # ---- #utk assign baris 1 ----
        fluidRow
        (
          #utk ngasii box utk dataset
          box(
            width = 12,
            title = "Pakistan Ecommerce Data in 2017",
            DT::DTOutput(outputId="dataset") #menyediakan output untuk tabel
          )
        )
      ) ## End of tabItem (page 4)
      
    ) # End of tabItems 
  ) #End of dashboardBody
  
) # End of dashboardPage



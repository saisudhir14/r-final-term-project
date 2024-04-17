# Load required packages
library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)
library(DT)

# Define UI
ui <- fluidPage(
  
  # App title
  titlePanel("Sales Analysis"),
  
  # Sidebar layout
  sidebarLayout(
    
    # Sidebar panel for inputs
    sidebarPanel(
      
      # Input: Select a file
      fileInput("file", "Choose CSV File",
                accept = c(".csv")),
      
      # Button to load data
      actionButton("loadData", "Load Data"),
      
      # Buttons for each visualization
      actionButton("showBarPlot", "Show Product Category Distribution"),
      actionButton("showScatterPlot", "Show Unit Price vs. Order Quantity"),
      actionButton("showPieChart", "Show Product Category Pie Chart"),
      actionButton("showBarPlotCountry", "Show Country Distribution"),
      actionButton("showBarPlotProfitAge", "Show Average Profit by Age Group")
      
    ),
    
    # Main panel for displaying outputs
    mainPanel(
      
      # Output: Data table
      DTOutput("data_table"),
      
      # Output: Plots
      plotOutput("bar_plot"),
      plotOutput("scatter_plot"),
      plotOutput("pie_chart"),
      plotOutput("bar_plot_country"),
      plotOutput("bar_plot_profit_age")
      
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Reactive values to store loaded data
  data <- reactiveValues(df = NULL)
  
  # Load data from CSV file
  observeEvent(input$loadData, {
    req(input$file)
    data$df <- read.csv(input$file$datapath, header = TRUE, stringsAsFactors = FALSE)
    # Additional data preprocessing steps can be added here
  })
  
  # Display loaded data in data table
  output$data_table <- renderDT({
    data$df
  })
  
  # Perform analysis and generate plots based on button clicks
  observeEvent(input$showBarPlot, {
    req(data$df)
    output$bar_plot <- renderPlot({
      ggplot(data$df, aes(x = Product_Category, fill = Age_Group)) +
        geom_bar(position = "dodge") +
        labs(title = "Product Category Distribution by Age Group",
             x = "Product Category",
             y = "Count") +
        theme_minimal()
    })
  })
  
  observeEvent(input$showScatterPlot, {
    req(data$df)
    output$scatter_plot <- renderPlot({
      ggplot(data$df, aes(x = Unit_Price, y = Order_Quantity)) +
        geom_point(color = "#0072B2", alpha = 0.6) +
        geom_smooth(method = "lm", se = FALSE, color = "#D55E00") +
        labs(title = "Unit Price vs. Order Quantity",
             x = "Unit Price",
             y = "Order Quantity") +
        theme_minimal() +
        theme(plot.title = element_text(hjust = 0.5))
    })
  })
  
  
  observeEvent(input$showPieChart, {
    req(data$df)
    output$pie_chart <- renderPlot({
      ggplot(data$df, aes(x = "", fill = Product_Category)) +
        geom_bar(width = 1, color = "white") +
        coord_polar("y") +
        labs(title = "Pie Chart of Product Category Distribution") +
        theme_minimal()
    })
  })
  
  observeEvent(input$showBarPlotCountry, {
    req(data$df)
    output$bar_plot_country <- renderPlot({
      ggplot(data$df, aes(x = Country)) +
        geom_bar() +
        labs(title = "Country Distribution",
             x = "Country",
             y = "Count") +
        theme_minimal()
    })
  })
  
  observeEvent(input$showBarPlotProfitAge, {
    req(data$df)
    output$bar_plot_profit_age <- renderPlot({
      ggplot(data$df, aes(x = Age_Group, y = Profit, fill = Age_Group)) +
        geom_bar(stat = "summary", fun = "mean") +
        labs(title = "Average Profit by Age Group",
             x = "Age Group",
             y = "Average Profit") +
        theme_minimal()
    })
  })
}

# Increase maximum upload size limit
options(shiny.maxRequestSize = 100*1024^2)  # Set to 100 MB

# Run the application
shinyApp(ui = ui, server = server)

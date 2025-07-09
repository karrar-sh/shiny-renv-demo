# server.R - Server Logic Definition
# Load required libraries for server
library(shiny)
library(ggplot2)

# Define datasets
datasets <- list(
  "mtcars" = mtcars,
  "iris" = iris,
  "faithful" = faithful
)

# Define server logic
server <- function(input, output, session) {
  
  # Reactive expression for selected dataset
  selected_data <- reactive({
    req(input$dataset)
    datasets[[input$dataset]]
  })
  
  # Dynamic UI for variable selection
  output$variable_ui <- renderUI({
    data <- selected_data()
    numeric_vars <- names(data)[sapply(data, is.numeric)]
    
    selectInput("variable",
                "Select Variable:",
                choices = numeric_vars,
                selected = numeric_vars[1])
  })
  
  # BUG ALERT: This histogram will crash for iris dataset!
  # Task 1: Students need to fix this
  output$histogram <- renderPlot({
    req(input$variable)
    req(input$bins)
    req(input$color)
    
    data <- selected_data()
    
    # INTENTIONAL BUG: This assumes all datasets have the same structure
    # Will fail when switching to iris dataset
    if(input$dataset == "mtcars") {
      hist(data[[input$variable]], 
           breaks = input$bins,
           main = paste("Distribution of", input$variable),
           xlab = input$variable,
           col = input$color,
           border = "white")
    } else if(input$dataset == "faithful") {
      hist(data[[input$variable]], 
           breaks = input$bins,
           main = paste("Distribution of", input$variable),
           xlab = input$variable,
           col = input$color,
           border = "white")
    }
    # MISSING: iris dataset case - this causes the crash!
    # Students need to add the iris case or make it generic
  })
  
  # MISSING FEATURE: Summary statistics output
  # Task 2: Students need to add this in both ui.R and server.R
  # 
   output$summary <- renderPrint({
     req(input$variable)
     data <- selected_data()
     summary(data[[input$variable]])
   })
  
  # Dataset information
  output$dataset_info <- renderPrint({
    data <- selected_data()
    cat("Dataset:", input$dataset, "\n")
    cat("Observations:", nrow(data), "\n")
    cat("Variables:", ncol(data), "\n")
    cat("Variable types:\n")
    str(data)
  })
  
  # Dataset descriptions
  output$dataset_description <- renderUI({
    description <- switch(input$dataset,
      "mtcars" = tagList(
        h5("Motor Trend Car Road Tests"),
        p("The data was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles."),
        h6("Variables:"),
        tags$ul(
          tags$li("mpg: Miles/(US) gallon"),
          tags$li("cyl: Number of cylinders"), 
          tags$li("disp: Displacement (cu.in.)"),
          tags$li("hp: Gross horsepower"),
          tags$li("drat: Rear axle ratio"),
          tags$li("wt: Weight (1000 lbs)"),
          tags$li("qsec: 1/4 mile time"),
          tags$li("vs: Engine (0 = V-shaped, 1 = straight)"),
          tags$li("am: Transmission (0 = automatic, 1 = manual)"),
          tags$li("gear: Number of forward gears"),
          tags$li("carb: Number of carburetors")
        )
      ),
      
      "iris" = tagList(
        h5("Edgar Anderson's Iris Data"),
        p("This famous dataset gives the measurements in centimeters of the variables sepal length and width and petal length and width, respectively, for 50 flowers from each of 3 species of iris."),
        h6("Variables:"),
        tags$ul(
          tags$li("Sepal.Length: Sepal length in cm"),
          tags$li("Sepal.Width: Sepal width in cm"),
          tags$li("Petal.Length: Petal length in cm"), 
          tags$li("Petal.Width: Petal width in cm"),
          tags$li("Species: Iris species (setosa, versicolor, virginica)")
        )
      ),
      
      "faithful" = tagList(
        h5("Old Faithful Geyser Data"),
        p("Waiting time between eruptions and the duration of the eruption for the Old Faithful geyser in Yellowstone National Park, Wyoming, USA."),
        h6("Variables:"),
        tags$ul(
          tags$li("eruptions: Eruption time in minutes"),
          tags$li("waiting: Waiting time to next eruption in minutes")
        )
      )
    )
    
    description
  })
  
  # Session info for debugging
  observeEvent(input$dataset, {
    cat("Dataset changed to:", input$dataset, "\n")
  })
  
  observeEvent(input$variable, {
    cat("Variable changed to:", input$variable, "\n")
  })
}
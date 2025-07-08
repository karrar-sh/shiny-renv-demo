# ui.R - User Interface Definition
# Load required libraries for UI
library(shiny)
library(bslib)

# Define datasets for dropdown
dataset_choices <- list(
  "Motor Trend Cars" = "mtcars",
  "Iris Flowers" = "iris", 
  "Old Faithful" = "faithful"
)

# Define UI
ui <- fluidPage(
  # Use modern Bootstrap theme
  theme = bs_theme(bootswatch = "flatly"),
  
  # Application title
  titlePanel("Data Explorer - Git Workshop Demo"),
  
  # Sidebar layout
  sidebarLayout(
    sidebarPanel(
      width = 3,
      
      # Dataset selection
      selectInput("dataset", 
                  "Choose Dataset:",
                  choices = dataset_choices,
                  selected = "mtcars"),
      
      # Variable selection (populated dynamically)
      uiOutput("variable_ui"),
      
      # Number of bins for histogram
      sliderInput("bins",
                  "Number of bins:",
                  min = 5,
                  max = 50,
                  value = 30),
      
      # Color selection
      selectInput("color",
                  "Plot color:",
                  choices = c("Blue" = "steelblue",
                             "Red" = "darkred", 
                             "Green" = "darkgreen",
                             "Purple" = "purple"),
                  selected = "steelblue"),
      
      hr(),
      
      # Workshop instructions
      h4("Workshop Tasks:"),
      p("1. Fix the Iris dataset bug"),
      p("2. Add summary statistics"),
      p("3. Review and merge changes"),
      
      br(),
      
      # About section
      h4("About"),
      p("This app demonstrates Git/GitHub workflows for collaborative development.")
    ),
    
    # Main panel with content
    mainPanel(
      width = 9,
      
      # Tabbed interface
      tabsetPanel(
        # Histogram tab
        tabPanel("Histogram", 
                 br(),
                 plotOutput("histogram", height = "400px"),
                 
                 # Space for summary statistics (Task 2 - students will add this)
                 # br(),
                 # h3("Summary Statistics"),
                 # verbatimTextOutput("summary")
        ),
        
        # Dataset info tab
        tabPanel("Dataset Info",
                 br(),
                 h4("Current Dataset Information:"),
                 verbatimTextOutput("dataset_info"),
                 
                 br(),
                 h4("Dataset Description:"),
                 uiOutput("dataset_description")
        ),
        
        # About tab
        tabPanel("About",
                 br(),
                 h3("Git Workshop Demo App"),
                 p("This Shiny application is designed to teach Git and GitHub workflows through hands-on practice."),
                 
                 h4("Learning Objectives:"),
                 tags$ul(
                   tags$li("Practice Git branching and merging"),
                   tags$li("Experience code review process"),
                   tags$li("Learn collaborative development"),
                   tags$li("Deploy applications with GitHub Pages")
                 ),
                 
                 h4("Technical Stack:"),
                 tags$ul(
                   tags$li("R Shiny for web application"),
                   tags$li("renv for package management"),
                   tags$li("Git for version control"),
                   tags$li("GitHub for collaboration and deployment"),
                   tags$li("VSCode for development environment")
                 )
        )
      )
    )
  )
)
library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Crime Map"),
  
  sidebarPanel(
    helpText("Create demographic maps with information from crime data."),
    selectInput("var", "Choose a variable to display",
                choices = c(
                  "Violent",
                  "Rape",
                  "Murder",
                  "Property"
                ),
                selected = "Violent"
    ),
    sliderInput("range", "Range of interest:",
                min = 0, max = 100, value = c(0, 100))
  ),
  mainPanel(
    plotOutput("mapPlot", height = "600px")
  )
))
library(shiny)
library(maps)
library(mapproj)

counties <- read.csv("data/crime.csv")

mp <- map("county", plot=FALSE, namesonly=TRUE)
c.order <- match(mp, 
                 paste(counties$region, counties$subregion, sep = ","))

shinyServer(function(input, output) {
  
  indexInput <- reactive({
    var <- switch(input$var, 
                  "Violent" = counties$violent,
                  "Rape" = counties$rape,
                  "Murder" = counties$murder,
                  "Property" = counties$property
                  )
    
    var <- pmax(var, input$range[1])
    var <- pmin(var, input$range[2])
    as.integer(cut(var, 100, include.lowest = TRUE, 
                   ordered = TRUE))[c.order]
  })
  
  shadesInput <- reactive({
    switch(input$var, 
           "Murder" = colorRampPalette(c("grey", "royalblue4"))(100),
           "Rape" = colorRampPalette(c("grey", "black"))(100),
           "Violent" = colorRampPalette(c("grey", "darkorange3"))(100),
           "Property" = colorRampPalette(c("grey", "darkviolet"))(100))
  })
  
  legendText <- reactive({  
    inc <- diff(range(input$range)) / 4
    c(paste0(input$range[1], " % or less"),
      paste0(input$range[1] + inc, " %"),
      paste0(input$range[1] + 2 * inc, " %"),
      paste0(input$range[1] + 3 * inc, " %"),
      paste0(input$range[2], " % or more"))
  })
  
  
  output$mapPlot <- renderPlot({
    fills <- shadesInput()[indexInput()]
    
    map("county", fill = TRUE, col = fills, 
        resolution = 0, lty = 0, projection="polyconic", 
        myborder = 0, mar = c(0,0,0,0))
    map("state",col = "white", fill=FALSE, add=TRUE, lty=1, 
        lwd=1,projection="polyconic", myborder = 0, 
        mar = c(0,0,0,0))
    legend("bottomleft", legend = legendText(), 
           fill = shadesInput()[c(1, 25, 50, 75, 100)], 
           title = input$var)
  })
})
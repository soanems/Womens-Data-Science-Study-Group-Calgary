# create the server functions for the dashboard  
server <- function(input, output) { 
  # Read dataset
  avocado <- read.csv('avocado.csv',stringsAsFactors = F, header=T)
  
  # Remove region = 'TotalUS'
  avocado <- avocado %>% filter(region != "TotalUS")
  
  #some data manipulation 
  avocado$Revenue <- avocado$AveragePrice * avocado$Total.Volume
  
  total.volume <- sum(avocado$Total.Volume)/1000
  total.revenue <- sum(avocado$Revenue)/1000
  total.bags <- sum(avocado$Total.Bags)/1000
  
  
  #creating the valueBoxOutput content
  output$value1 <- renderValueBox({
    valueBox(
      formatC(total.volume, format="d", big.mark=',')
      ,paste('Total Volume (K)')
      ,icon = icon("stats",lib='glyphicon')
      ,color = "purple")
  })
  output$value2 <- renderValueBox({
    valueBox(
      formatC(total.revenue, format="d", big.mark=',')
      ,'Total Revenue (K)'
      ,icon = icon("usd",lib='glyphicon')
      ,color = "green")
  })
  
  output$value3 <- renderValueBox({
    valueBox(
      formatC(total.bags, format="d", big.mark=',')
      ,paste('Total bags (K)')
      ,icon = icon("menu-hamburger",lib='glyphicon')
      ,color = "yellow")
    
  })
  
  #creating the plotOutput content
  
  # output$revenuebyType <- renderPlot({
  #   ggplot(data = avocado, 
  #          aes(x=type, y=Revenue, fill=factor(year))) + 
  #     geom_bar(position = "dodge", stat = "identity") + ylab("Revenue") + 
  #     xlab("Type") + theme(legend.position="bottom" 
  #                          ,plot.title = element_text(size=15, face="bold")) +
  #     labs(fill = "Year")
  # })
  
  output$perbyType <- renderPlot({
    
    mycols <- c("forestgreen", "blue")
    
    ggplot(type_volume, aes(x = "", y = Total.Volume, fill = type)) +
      geom_bar(width = 1, stat = "identity", color = "white") +
      coord_polar("y", start = 0)+
      scale_fill_manual(values = mycols) +
      theme_void()
  })  
  
  output$totalbyType <- renderPlot({
    ggplot(data = avocado, 
           aes(x=type, y=Total.Volume, fill=factor(year))) + 
      geom_bar(position = "dodge", stat = "identity") + ylab("Total") + 
      xlab("Type") + theme(legend.position="bottom", 
                           plot.title = element_text(size=15, face="bold")) + 
      labs(fill = "Year")
  })
  
  output$barline <- renderPlot({
    avocado_day <- avocado %>%
      group_by(Date) %>%
      summarize(Revenue = sum(Revenue),
                Total.Volume = sum(Total.Volume),
                Total.Bags = sum(Total.Bags))
    
    ggplot(avocado_day, aes(x = Date)) +
      geom_col(aes( y = Total.Volume, fill="forestgreen")) +
      geom_line(aes(y = Revenue, group = 1, color = 'blackline')) +
      scale_y_continuous(sec.axis = sec_axis(trans = ~ .)) +
      scale_fill_manual('', labels = 'Volume', values = "forestgreen") +
      scale_color_manual('', labels = 'Date', values = 'black') +
      theme_minimal()
  })
}
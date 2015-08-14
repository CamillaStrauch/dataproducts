
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
today <- Sys.Date()

shinyUI(fluidPage(

  # Application title
  titlePanel("Developing Data Products Course Project:  Future Work Hours"),

     sidebarPanel(
       h3('Documentation:'),
       helpText("The Pie chart show the split between work hours and spare time",
                "in the given time period",br(),br(),"The values entered in this Input Panel",
                "will be used to generate the Pie chart in the Output Panel",
                "upon click of the ",em('Calculate'),"-button"
                ),
       submitButton('Calculate'),
       h3('Input Panel'),
       dateRangeInput("Period", "Work Time Period", 
                      start = today, end = (today+7), 
                      min = today, max = "2026-01-01", 
                      format = "yyyy-mm-dd", 
                      startview = "month", 
                      weekstart = 0, 
                      language = "en", 
                      separator = " to "),
       helpText("Note:", br(),
                "The dates should be entered in the format 'YYYY-MM-DD' ", br(),
                "The date on the right side should be newer than the date on the left side", br(),
                "Min: The current date is the oldest possible date", br(),
                "Max: 2016-01-01"
                ),
       sliderInput("Workhours", "Work hours pr day", 
                   min=0, max=24, 
                   value=7.4, step = 0.1, 
                   round = FALSE, 
                   format = "#,##0.#####", 
                   locale = "us", 
                   ticks = TRUE, 
                   animate = FALSE),
       helpText("Note: The average number of work hours pr. workday is set by moving the slider above"),
       radioButtons("Days2Include", "Method for days to be included:",
                    c("1: Every day in the period" = "1",
                      "2: Only weekdays" = "2",
                      "3: Weekdays excluding Danish National Holidays" = "3")),
       helpText("Indicate whether or not every day within the period is a work day" ),
       numericInput("Vacationdays2Exclude", 
                    "Number of vacation days to exclude (from the days given by the choosen method)", 
                     value = 0, 
                     min = 0, 
                     max = NA, 
                     step = NA)
       
  
   ),
  # Show the choosen values required for calculation
    mainPanel(
      br(),
      h3('Output Panel'),
      plotOutput('newPie'),
      h3('Values used during the calculation'),
      helpText("The values shown below were used to generate the Pie chart above", br()),
      h4('Work Time Period'),
      verbatimTextOutput("oPeriod"),
      h4('Work hours pr day'),
      verbatimTextOutput("oWorkhours"),
      h4('Choosen method for days to be included'),
      verbatimTextOutput("oDays2Include"),
      h4('Number of Vacation days to exclude'),
      verbatimTextOutput("oVacationdays2Exclude")
    )
  )
)

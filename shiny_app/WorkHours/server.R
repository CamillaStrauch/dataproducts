
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
min_day <<- Sys.Date()
max_day <<- as.Date("2026-01-01")

## Danish National Holidays that appear on a weekday:
## -----------------------------------------------------
## New Years Day (Jan 1)
New_Years_Days         <- data.frame(  date=as.Date( c("2016-01-01","2018-01-01", 
                                                "2019-01-01","2020-01-01","2021-01-01",
                                                "2024-01-01","2025-01-01") ),
                                       holiday="New Years Day"  )
## Maundy Thursday 
Maundy_Thursdays       <- data.frame(  date=as.Date( c("2016-03-24","2017-04-13","2018-03-29", 
                                                  "2019-04-18","2020-04-09","2021-04-01","2022-04-14","2023-04-06","2024-03-28",
                                                  "2025-04-17") ),
                                       holiday="Maundy Thursday")
## Good Friday 
Good_Fridays          <- data.frame(   date=as.Date( c("2016-03-25","2017-04-14","2018-03-30", 
                                              "2019-04-19","2020-04-10","2021-04-02",
                                              "2022-04-15","2023-04-07","2024-03-29","2025-04-18") ),
                                       holiday="Good Friday")
## Easter Monday 
Easter_Mondays        <- data.frame(   date=as.Date( c("2016-03-28","2017-04-17","2018-04-02", 
                                                "2019-04-22","2020-04-13","2021-04-05",
                                                "2022-04-18","2023-04-10","2024-04-01",
                                                "2025-04-21")),
                                       holiday="Easter Monday")
## Prayer Day 
Prayer_Days           <- data.frame(   date=as.Date( c("2016-04-22","2017-05-12","2018-04-27", 
                                             "2019-05-17","2020-05-08","2021-04-30",
                                             "2022-05-13","2023-05-05","2024-04-26",
                                             "2025-05-16")),
                                        holiday="Prayer Day")
## Christ's Ascension 
CA_Days               <- data.frame(    date=as.Date( c("2016-05-05","2017-05-25","2018-05-10", 
                                         "2019-05-30","2020-05-21","2021-05-13",
                                         "2022-05-26","2023-05-18","2024-05-09",
                                         "2025-05-29")),
                                        holiday="Christ's Ascension")
## Whit Monday
Whit_Mondays          <- data.frame(    date=as.Date( c("2016-05-16","2017-06-05","2018-05-21", 
                                              "2019-06-10","2020-06-01","2021-05-24",
                                              "2022-06-06","2023-05-29","2024-05-20",
                                              "2025-06-09")),
                                        holiday="Whit Monday")
## Christmas Eve Day (Dec 24)
Christmas_Eve_Days    <- data.frame(    date=as.Date( c("2015-12-24","2018-12-24", 
                                                    "2019-12-24","2020-12-24","2021-12-24",
                                                    "2024-12-24", "2025-12-24")),
                                        holiday="Christmas Eve Day")
## Christmas Day (Dec 25)
Christmas_Days        <- data.frame(    date=as.Date( c("2015-12-25","2017-12-25","2018-12-25", 
                                                "2019-12-25","2020-12-25","2023-12-25","2024-12-25",
                                                "2025-12-25")),
                                        holiday="Christmas Day")

## Second Day of Christmas (Dec 26)
Second_Christmas_Days <- data.frame(    date=as.Date( c("2016-12-26","2017-12-26","2018-12-26", 
                                                       "2019-12-26","2022-12-26","2023-12-26",
                                                       "2024-12-26","2025-12-26")),
                                        holiday="Second Day of Christmas")

DK_holidays_on_weekdays <- rbind(New_Years_Days, 
                                 Maundy_Thursdays,
                                 Good_Fridays,
                                 Easter_Mondays,
                                 Prayer_Days,
                                 CA_Days,
                                 Whit_Mondays,
                                 Christmas_Eve_Days,
                                 Christmas_Days,
                                 Second_Christmas_Days)

cWorkhours <- function(pPeriodStart=min_day,
                       pPeriodEnd=max_day,
                       pHolidays=DK_holidays_on_weekdays,
                       pDays2Include="1",
                       pWorkHours=7.4,
                       pVacationdays2Exclude=0)
{
  if (pPeriodEnd > pPeriodStart){
    TotalDays  = as.numeric(pPeriodEnd -pPeriodStart)
    TotalHours = 24 * TotalDays
    WorkDays = TotalDays
    if (pDays2Include!="1"){
      hole_weeks = floor(TotalDays/7)
      surplus_days = TotalDays - 7*hole_weeks
      
      add_weekenddays = 0
      if (surplus_days > 0){
        weekno = as.numeric(pPeriodStart, format="%u") 
        if ( (weekno < 6) && (weekno + surplus_days)>=7){
           add_weekends = 2
        }
        if ( (weekno == 6) ){
          add_weekends = 1
        }
        if ( (weekno + surplus_days)==6 ) {
          add_weekends = 1
        }
      }
      
      WeekendDays = 2*hole_weeks+add_weekenddays
      
      WorkDays = TotalDays - WeekendDays
      if (pDays2Include =="3"){
        holidays = nrow(pHolidays[ with(pHolidays, date > pPeriodStart & date <= pPeriodEnd), ])
        WorkDays = TotalDays - WeekendDays - holidays
      }
    }
    if ((pVacationdays2Exclude>0)&&(pVacationdays2Exclude < WorkDays)){
         WorkDays = WorkDays - pVacationdays2Exclude
    }
    if (pVacationdays2Exclude >= WorkDays){
      WorkDays = 0
    }
    WorkHours = pWorkHours * WorkDays  
  }
  else {
    TotalHours = 0
    WorkHours = 0
    }
  result <- list("TotalHours"=TotalHours, "WorkHours"=WorkHours)
  return(result)
}

shinyServer(function(input, output) {
  output$oPeriod <- renderPrint({ input$Period })
  output$oWorkhours <- renderPrint({ input$Workhours })
  output$oDays2Include <- renderPrint({input$Days2Include})
  output$oVacationdays2Exclude <- renderPrint({input$Vacationdays2Exclude})
  output$newPie <- renderPlot({result <- cWorkhours(pPeriodStart=input$Period[1],
                                                    pPeriodEnd=input$Period[2],
                                                    pDays2Include=input$Days2Include,
                                                    pWorkHours=input$Workhours,
                                                    pVacationdays2Exclude=input$Vacationdays2Exclude)
                                 # Simple Pie Chart
                                 SpareTime <- result$TotalHours - result$WorkHours
                                 slices <- c(result$WorkHours, SpareTime)
                                 pct <- round(slices/result$TotalHours*100)
                                 lbls <- c("Work hours:", "Spare time:")
                                 lbls <- paste(lbls, round(slices))
                                 lbls <- paste(lbls, "hours or")
                                 lbls <- paste(lbls, pct) # add percents to labels 
                                 lbls <- paste(lbls,"%",sep=" ") # ad % to labels
                                 pie(slices, 
                                 labels = lbls, 
                                 main="Work hours and Sparetime within the Work Time Period")})
})

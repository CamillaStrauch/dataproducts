Developing Data Products Course Project - WorkHours 
The 'WorkHours'-Shiny app  
========================================================
author: Camilla Strauch
date: 2015-08-17

Pitch for the 'WorkHours'- Shiny app 
========================================================

The **'WorkHours'**-Shiny app provides an easy way for estimating future work hours within a given **time period of interest**.

The user is offered the possiblity to exclude **weekends**, any **Danish Holidays** that may fall on a weekday _(these include New Years Day, Maundy Thursday, Good Friday, Easter Monday, Prayer Day, Christ's Ascension, Whit Monday, Christmas Eve Day, Christmas Day, Second Day of Christmas)_ and a **variable number of vacation days** 

The app is located at:
**https://camillastrauch.shinyapps.io/WorkHours**

How it works 
========================================================

1. The user enters the **input** values in the **Input-Panel**
   _( or uses the defaults)_
2. The user presses the **Calculate**-button
3. A **Pie-chart** is updated and shown in the **Output-Panel** along with the values that were used for generating the Pie-chart showing the split between work hours and spare time in **procent** and **actual count of hours** _(see the Sample Pie-chart on the next slide  )_

Sample Pie-chart 
========================================================

![plot of chunk unnamed-chunk-1](WorkHours_Pitch-figure/unnamed-chunk-1-1.png) 



Inputs / Default values
========================================================

1. A Time Period given by a **Start**-date and an **End**- date 
  + The **Start**-date is by default the **current date**
  + The **End**-date is by default the date **one week ahead**

2. Average **Work Hours** per work day
  + The default value is **7.4 hours**
  
3. The **Method** for determining the max. number of work days within the period
  + By default method **'1:Every day in the period'** is choosen 

4. The count of **Vacation days** to substract from the max. number of work days in order to get the actual count of work days 
  + **zero** days is default



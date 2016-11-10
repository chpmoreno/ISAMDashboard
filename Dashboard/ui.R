# Define the overall UI
header <- dashboardHeader(
  title = "Financial Institutions Sentiment Analysis - FISA (0.0.1)",
  titleWidth = "800px"
)

sidebar <- dashboardSidebar(
  sidebarUserPanel(
    "DODM",
    subtitle = a(href = "#", icon("circle", class = "text-success"), "Online"),
    # Image file should be in www/ subdir
    image = "Barcelonagse.jpg"
  ),
  sidebarMenu(
    id = "tabs",
    menuItem(
      "Sentiment Index",
      tabName = "SI",
      icon = icon("line-chart")
    ),
    menuItem(
      "Documents",
      tabName = "DOCP",
      icon = icon("file-pdf-o")
    )
  ),
  sidebarMenuOutput("menu")
)

body <- dashboardBody(
  tabItems(
    # SI ####
    tabItem("SI",
            fluidRow(
              tabBox(title = "Filters",
                     id = "tabset1_SI", height = 320,
                     tabPanel("Sentiment Index Filter",
                              radioButtons("indicatortype_SI", "Indicator type:",
                                           c("rss" = "rss_type_SI",
                                             "lough" = "lough_type_SI"),
                                           selected = "lough_type_SI",
                                           inline = TRUE),
                              dateRangeInput("fechasini_SI",
                                             "Range",
                                             start = fecha_range_ini[1], 
                                             end   = fecha_range_ini[2]),
                              selectInput("entidad_SI", "Entidad:", 
                                          choices = entidades,
                                          selected = "all"),
                              selectInput("serie_SI", "Serie:", 
                                          choices = c("none", colnames(timeseries)[!str_detect(colnames(timeseries), "smooth")][!str_detect(colnames(timeseries)[!str_detect(colnames(timeseries), "smooth")],"yearmonth")]),
                                          selected = "none")
                     )
              ),
              valueBoxOutput("vbox_Correlation"),
              valueBoxOutput("vbox_GrangerTest")
            ),
            tags$br(),
            box(title = 'Sentiment by group of documents:',
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                width = 14,
                fluidRow(
                  column(12,
                         plotlyOutput("PlotSentimentIndex_SI", height = 600)  
                  )
                )
            ),
            box(title = 'Sentiment Index and other variables data:',
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                collapsed = TRUE,
                width = 14,
                fluidRow(
                  column(12,
                         tabsetPanel(
                           id = 'dataset_timeseries_SI',
                           tabPanel('Series', DT::dataTableOutput('timeseries_SI_table'))
                         )
                  )
                )
            )
    ),
    #DOCP ####
    tabItem("DOCP",
            fluidRow(
              tabBox(title = "Filters",
                     id = "tabset1_DOCP", height = 320,
                     tabPanel("Documents Sentiment Filter",
                              radioButtons("indicatortype_DOCP", "Indicator type:",
                                                 c("rss" = "rss_type_DOCP",
                                                   "lough" = "lough_type_DOCP"),
                                                 selected = "lough_type_DOCP",
                                                 inline = TRUE),
                              checkboxGroupInput("posnegind_DOCP", "Sentiment:",
                                                 c("Positive" = "positive",
                                                   "Negative" = "negative",
                                                   "Neutral" = "neutral"),
                                                 selected = c("positive", "negative",
                                                              "neutral"),
                                                 inline = TRUE),
                              dateRangeInput("fechasini_DOCP",
                                             "Range",
                                             start = fecha_range_ini[1], 
                                             end   = fecha_range_ini[2]),
                              selectInput("entidad_DOCP", "Entidad:", 
                                          choices = entidades,
                                          selected = "all")
                      ),
                     tabPanel("WordClouds Filter",
                              sliderInput("Numberofwords_DOCP",
                                          "Number of words",
                                          min = 20,
                                          max = 200,
                                          value = 100)
                     )
              ),
              valueBoxOutput("vbox_totalDocuments_DOCP"),
              valueBoxOutput("vbox_selectedDocuments_DOCP")
            ),
            tags$br(),
            box(title = 'Sentiment by group of documents:',
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                width = 14,
                fluidRow(
                  column(12,
                         plotOutput("PlotDocuments_DOCP", 
                                    brush = "PlotDocuments_DOCP_brush",
                                    height = 500)  
                  )
                )
            ),
            box(title = 'WordCloud by group of documents:',
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                width = 14,
                fluidRow(
                  column(12,
                         plotOutput("PlotWordCloudDocuments3_DOCP")
                  )
                ),
                tags$br(),
                fluidRow(
                  column(6,
                         plotOutput("PlotWordCloudDocuments1_DOCP")
                  ),
                  column(6,
                         plotOutput("PlotWordCloudDocuments2_DOCP")
                  )
                )
            ),
            box(title = 'Word Cloud Data:',
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                collapsed = TRUE,
                width = 14,
                fluidRow(
                  column(12,
                         tabsetPanel(
                           id = 'dataset_DOCP',
                           tabPanel('freq', DT::dataTableOutput('tablefreqdist_DOCP')),
                           tabPanel('bifreq', DT::dataTableOutput('tablebifreqdist_DOCP')),
                           tabPanel('trifreq', DT::dataTableOutput('tabletrifreqdist_DOCP'))
                         )
                  )
                )
            )
    )
  )
)
dashboardPage(header, sidebar, body)
# Define server logic required to draw a histogram
shinyServer(function(input, output){
  # 1. Data ####
  # 1.1 DOCP ####
  dataini_DOCP <- reactive({
    if(input$entidad_DOCP == "all"){
      if(input$indicatortype_DOCP == "rss_type_DOCP"){
        info %>% dplyr::filter(rss_sign %in% input$posnegind_DOCP) %>% 
                 dplyr::filter(as.Date(fecha_dia) >= input$fechasini_DOCP[1] & as.Date(fecha_dia) <= input$fechasini_DOCP[2])
      }else{
        info %>% dplyr::filter(lough_sign %in% input$posnegind_DOCP) %>% 
                 dplyr::filter(as.Date(fecha_dia) >= input$fechasini_DOCP[1] & as.Date(fecha_dia) <= input$fechasini_DOCP[2])
      }
    }else{
      if(input$indicatortype_DOCP == "rss_type_DOCP"){
        info %>% dplyr::filter(rss_sign %in% input$posnegind_DOCP) %>% 
                 dplyr::filter(as.Date(fecha_dia) >= input$fechasini_DOCP[1] & as.Date(fecha_dia) <= input$fechasini_DOCP[2]) %>% 
                 dplyr::filter(entidad == input$entidad_DOCP)
      }else{
        info %>% dplyr::filter(lough_sign %in% input$posnegind_DOCP) %>% 
                 dplyr::filter(as.Date(fecha_dia) >= input$fechasini_DOCP[1] & as.Date(fecha_dia) <= input$fechasini_DOCP[2]) %>%
                 dplyr::filter(entidad == input$entidad_DOCP)
      }
    }
  })
  idaux <- reactive({
      as.character(unique(dataini_DOCP()$id))
  })
  brushaux_PlotDocuments <- reactive({
    as.character(unique(brushedPoints(dataini_DOCP(), input$PlotDocuments_DOCP_brush)$id))
  })
  dataini_DOCPfreqdist <- reactive({
    if(length(brushaux_PlotDocuments())==0){
      freqdisttfidf %>% dplyr::filter(id %in% idaux()) %>%  
                        dplyr::group_by(ngrama) %>% 
                        dplyr::summarise(tfidf_mean = mean(tfidf)) %>% 
                        dplyr::arrange(desc(tfidf_mean)) %>% dplyr::filter(row_number() <= input$Numberofwords_DOCP)
    }else{
      freqdisttfidf %>% dplyr::filter(id %in% brushaux_PlotDocuments()) %>%  
                        dplyr::group_by(ngrama) %>% 
                        dplyr::summarise(tfidf_mean = mean(tfidf)) %>% 
                        dplyr::arrange(desc(tfidf_mean)) %>% dplyr::filter(row_number() <= input$Numberofwords_DOCP)
    }
  })
  dataini_DOCPbifreqdist <- reactive({
    if(length(brushaux_PlotDocuments())==0){
      bifreqdisttfidf %>% dplyr::filter(id %in% idaux()) %>%  
                          dplyr::group_by(ngrama) %>% 
                          dplyr::summarise(tfidf_mean = mean(tfidf)) %>% 
                          dplyr::arrange(desc(tfidf_mean)) %>% dplyr::filter(row_number() <= input$Numberofwords_DOCP)
    }else{
      bifreqdisttfidf %>% dplyr::filter(id %in% brushaux_PlotDocuments()) %>%  
                          dplyr::group_by(ngrama) %>% 
                          dplyr::summarise(tfidf_mean = mean(tfidf)) %>% 
                          dplyr::arrange(desc(tfidf_mean)) %>% dplyr::filter(row_number() <= input$Numberofwords_DOCP)
    }
  })
  dataini_DOCPtrifreqdist <- reactive({
    if(length(brushaux_PlotDocuments())==0){
      trifreqdisttfidf %>% dplyr::filter(id %in% idaux()) %>%  
                           dplyr::group_by(ngrama) %>% 
                           dplyr::summarise(tfidf_mean = mean(tfidf)) %>% 
                           dplyr::arrange(desc(tfidf_mean)) %>% dplyr::filter(row_number() <= input$Numberofwords_DOCP)
    }else{
      trifreqdisttfidf %>% dplyr::filter(id %in% brushaux_PlotDocuments()) %>%  
                           dplyr::group_by(ngrama) %>% 
                           dplyr::summarise(tfidf_mean = mean(tfidf)) %>% 
                           dplyr::arrange(desc(tfidf_mean)) %>% dplyr::filter(row_number() <= input$Numberofwords_DOCP)
    }
  })
  # 1.2 SI ####
  dataini_SI <- reactive({
    if(input$entidad_SI == "all"){
        info %>% dplyr::filter(as.Date(fecha_dia) >= input$fechasini_SI[1] & as.Date(fecha_dia) <= input$fechasini_SI[2])
    }else{
        info %>% dplyr::filter(as.Date(fecha_dia) >= input$fechasini_SI[1] & as.Date(fecha_dia) <= input$fechasini_SI[2]) %>% 
                 dplyr::filter(entidad == input$entidad_SI)
    }
  })
  rss_index_yearly_SI <- reactive({
    dataini_SI() %>% group_by(year = year(fecha_dia)) %>% summarise(rss_index = mean(rss))
  })
  rss_index_bymonth_SI <- reactive({
    dataini_SI() %>% group_by(month = month(fecha_dia)) %>% summarise(rss_index = mean(rss))
  })
  rss_index_monthly_SI <- reactive({
    dataini_SI() %>% group_by(yearmonth = (str_sub(fecha_dia, 1, 7))) %>% summarise(rss_index = mean(rss))
  })
  lough_index_yearly_SI <- reactive({
    dataini_SI() %>% group_by(year = year(fecha_dia)) %>% summarise(lough_index = mean(lough))
  })
  lough_index_bymonth_SI <- reactive({
    dataini_SI() %>% group_by(month = month(fecha_dia)) %>% summarise(lough_index = mean(lough))
  })
  lough_index_monthly_SI <- reactive({
    dataini_SI() %>% group_by(yearmonth = (str_sub(fecha_dia, 1, 7))) %>% summarise(lough_index = mean(lough))
  })
  timeseries_SI <- reactive({
    rss_index_smooth <- loess(rss_index~seq_along(yearmonth), data = rss_index_monthly_SI(), span = 0.15)$fit
    lough_index_smooth <- loess(lough_index~seq_along(yearmonth), data = lough_index_monthly_SI(), span = 0.15)$fit
    left_join(rss_index_monthly_SI(), lough_index_monthly_SI()) %>% cbind(rss_index_smooth, lough_index_smooth) %>%
    left_join(timeseries)
  })
  # 2. Plots ####
  # 2.1 Plots  DOCP ####
  PlotDocuments_DOCP <- reactive({
    if(input$indicatortype_DOCP == "rss_type_DOCP"){
      ggplot(dataini_DOCP(), aes(x = fecha_dia, y = rss)) + geom_point(aes(color = rss_sign)) +
        scale_color_manual(name = "", values = colorsign) +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 90, size = 14, hjust = 1, vjust = 0.5),
              axis.text.y = element_text(size = 14, hjust = 1, vjust = 0.5),
              axis.title.y = element_text(size = 14),
              legend.position = "bottom",
              legend.text = element_text(size = 14),
              plot.margin = unit(c(5,4,0,0), "mm")) + labs(x = "") +
        scale_x_datetime(date_labels = "%b %y",
                         date_breaks = 
                           ifelse(as.numeric((max(dataini_DOCP()$fecha_dia) - min(dataini_DOCP()$fecha_dia))/365) <= 1,
                                  "1 month",
                                  ifelse(as.numeric((max(dataini_DOCP()$fecha_dia) - min(dataini_DOCP()$fecha_dia))/365) > 1 &
                                           as.numeric((max(dataini_DOCP()$fecha_dia) - min(dataini_DOCP()$fecha_dia))/365) <= 3,
                                         "4 month",
                                         ifelse(as.numeric((max(dataini_DOCP()$fecha_dia) - min(dataini_DOCP()$fecha_dia))/365) > 3 &
                                                  as.numeric((max(dataini_DOCP()$fecha_dia) - min(dataini_DOCP()$fecha_dia))/365) <= 10,
                                                "6 month", "12 month"
                                         )
                                  )
                           ) 
        )
    }else{
      ggplot(dataini_DOCP(), aes(x = fecha_dia, y = lough)) + geom_point(aes(color = lough_sign)) +
        scale_color_manual(name = "", values = colorsign) +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 90, size = 14, hjust = 1, vjust = 0.5),
              axis.text.y = element_text(size = 14, hjust = 1, vjust = 0.5),
              axis.title.y = element_text(size = 14),
              legend.position = "bottom",
              legend.text = element_text(size = 14),
              plot.margin = unit(c(5,4,0,0), "mm")) + labs(x = "") +
        scale_x_datetime(date_labels = "%b %y",
                         date_breaks = 
                           ifelse(as.numeric((max(dataini_DOCP()$fecha_dia) - min(dataini_DOCP()$fecha_dia))/365) <= 1,
                                  "1 month",
                                  ifelse(as.numeric((max(dataini_DOCP()$fecha_dia) - min(dataini_DOCP()$fecha_dia))/365) > 1 &
                                           as.numeric((max(dataini_DOCP()$fecha_dia) - min(dataini_DOCP()$fecha_dia))/365) <= 3,
                                         "4 month",
                                         ifelse(as.numeric((max(dataini_DOCP()$fecha_dia) - min(dataini_DOCP()$fecha_dia))/365) > 3 &
                                                  as.numeric((max(dataini_DOCP()$fecha_dia) - min(dataini_DOCP()$fecha_dia))/365) <= 10,
                                                "6 month", "12 month"
                                         )
                                  )
                           ) 
        )
    }
  })
  output$PlotDocuments_DOCP <- renderPlot({
    PlotDocuments_DOCP()
  })
  PlotWordCloudDocuments1_DOCP <- reactive({
    tagcloud(dataini_DOCPfreqdist()$ngrama, 
             weights = dataini_DOCPfreqdist()$tfidf_mean/sum(dataini_DOCPfreqdist()$tfidf_mean), 
             col = colorRampPalette(brewer.pal(12, "Paired"))(nrow(dataini_DOCPfreqdist())), 
             family = "Ubuntu Medium")
  })
  output$PlotWordCloudDocuments1_DOCP <- renderPlot({
    plot(PlotWordCloudDocuments1_DOCP())
  }, bg = "black")
  PlotWordCloudDocuments2_DOCP <- reactive({
    tagcloud(dataini_DOCPbifreqdist()$ngrama, 
             weights = dataini_DOCPbifreqdist()$tfidf_mean/sum(dataini_DOCPbifreqdist()$tfidf_mean), 
             col = colorRampPalette(brewer.pal(12, "Paired"))(nrow(dataini_DOCPbifreqdist())), 
             family = "Ubuntu Medium")
  })
  output$PlotWordCloudDocuments2_DOCP <- renderPlot({
    plot(PlotWordCloudDocuments2_DOCP())
  }, bg = "black")
  PlotWordCloudDocuments3_DOCP <- reactive({
    tagcloud(dataini_DOCPtrifreqdist()$ngrama, 
             weights = dataini_DOCPtrifreqdist()$tfidf_mean/sum(dataini_DOCPtrifreqdist()$tfidf_mean), 
             col = colorRampPalette(brewer.pal(12, "Paired"))(nrow(dataini_DOCPtrifreqdist())), 
             family = "Ubuntu Medium")
  })
  output$PlotWordCloudDocuments3_DOCP <- renderPlot({
    plot(PlotWordCloudDocuments3_DOCP())
  }, bg = "black")
  # 2.2 Plots ####
  PlotSentimentIndex_SI <- reactive({
    if(input$indicatortype_SI == "rss_type_SI"){
      if(input$serie_SI == "none"){
        plot_ly(data = timeseries_SI(), x = ~as.Date(paste0(yearmonth,"-01"))) %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~-rss_index, name = "rss") %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~-rss_index_smooth, name = "rss_smooth") %>% 
          layout(legend = list(font = list(size = 0.1), x = 1.12, y = 1.2),
                 xaxis = list(title = "", showgrid = FALSE, ticks = "outside", showline = TRUE, mirror = TRUE, tickangle = 90, zeroline = FALSE),
                 yaxis = list(autorange = TRUE, title = "RSS", showgrid = FALSE, ticks = "", showline = TRUE, mirror = TRUE, zeroline = FALSE),
                 margin = list(l = 80, r = 50, b = 90, pad = 4))
      }else{
        plot_ly(data = timeseries_SI(), x = ~as.Date(paste0(yearmonth,"-01"))) %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~-rss_index, name = "rss") %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~-rss_index_smooth, name = "rss_smooth") %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~timeseries_SI()[,input$serie_SI], yaxis = "y2", name = input$serie_SI) %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~timeseries_SI()[,paste0(input$serie_SI, "_smooth")], yaxis = "y2", name = paste0(input$serie_SI, "_smooth")) %>%
          layout(legend = list(font = list(size = 0.1), x = 1.12, y = 1.2),
                 xaxis = list(title = "", showgrid = FALSE, ticks = "outside", showline = TRUE, mirror = TRUE, tickangle = 90, zeroline = FALSE),
                 yaxis = list(title = "RSS", showgrid = FALSE, ticks = "", showline = TRUE, mirror = TRUE, zeroline = FALSE),
                 yaxis2 = list(autorange = info_axis[info_axis$Serie == input$serie_SI, "Eje"], ticks = "", overlaying = "y", side = "right", showgrid = FALSE, title = input$serie_SI, zeroline = FALSE),
                 margin = list(l = 80, r = 50, b = 90, pad = 4))
      }
    }else{
      if(input$serie_SI == "none"){
        plot_ly(data = timeseries_SI(), x = ~as.Date(paste0(yearmonth,"-01"))) %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~-lough_index, name = "lough") %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~-lough_index_smooth, name = "lough_smooth") %>% 
          layout(legend = list(font = list(size = 0.1), x = 1.12, y = 1.2),
                 xaxis = list(title = "", showgrid = FALSE, ticks = "outside", showline = TRUE, mirror = TRUE, tickangle = 90, zeroline = FALSE),
                 yaxis = list(autorange = TRUE, title = "lough", showgrid = FALSE, ticks = "", showline = TRUE, mirror = TRUE, zeroline = FALSE),
                 margin = list(l = 80, r = 50, b = 90, pad = 4))
      }else{
        plot_ly(data = timeseries_SI(), x = ~as.Date(paste0(yearmonth,"-01"))) %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~-lough_index, name = "lough") %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~-lough_index_smooth, name = "lough_smooth") %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~timeseries_SI()[,input$serie_SI], yaxis = "y2", name = input$serie_SI) %>%
          add_lines(x = ~as.Date(paste0(yearmonth,"-01")), y = ~timeseries_SI()[,paste0(input$serie_SI, "_smooth")], yaxis = "y2", name = paste0(input$serie_SI, "_smooth")) %>%
          layout(legend = list(font = list(size = 0.1), x = 1.12, y = 1.2),
                 xaxis = list(title = "", showgrid = FALSE, ticks = "outside", showline = TRUE, mirror = TRUE, tickangle = 90, zeroline = FALSE),
                 yaxis = list(title = "lough", showgrid = FALSE, ticks = "", showline = TRUE, mirror = TRUE, zeroline = FALSE),
                 yaxis2 = list(autorange = info_axis[info_axis$Serie == input$serie_SI, "Eje"], ticks = "", overlaying = "y", side = "right", showgrid = FALSE, title = input$serie_SI, zeroline = FALSE),
                 margin = list(l = 80, r = 50, b = 90, pad = 4))
      }
    }
  })
  output$PlotSentimentIndex_SI <- renderPlotly({
    PlotSentimentIndex_SI()
  })
  # 3 Output Boxes ####
  # 3.1 Output Boxes  DOCP ####
  output$vbox_totalDocuments_DOCP <- renderValueBox({
    valueBox(nrow(dataini_DOCP()),
      "# of documents",
      icon = icon("files-o")
    )
  })
  output$vbox_selectedDocuments_DOCP <- renderValueBox({
    valueBox(length(brushaux_PlotDocuments()),
             "# of documents in the selection",
             icon = icon("files-o"),
             color = "purple"
    )
  })
  # 3.2 Output Boxes SI ####
  vbox_Correlation <- reactive({
    if(input$indicatortype_SI == "rss_type_SI"){
      if(input$serie_SI == "none"){
        "n.a."
      }else{
        if(info_axis[info_axis$Serie == input$serie_SI, "Eje"] == TRUE){
          correlationtest <- cor.test(-timeseries_SI()[, "rss_index"],timeseries_SI()[, input$serie_SI])
          paste0(round(as.numeric(correlationtest$estimate),2),
                 " / ", round(as.numeric(correlationtest$p.value),2))
        }else{
          correlationtest <- cor.test(-timeseries_SI()[, "rss_index"],-timeseries_SI()[, input$serie_SI])
          paste0(round(as.numeric(correlationtest$estimate),2),
                 " / ", round(as.numeric(correlationtest$p.value),2))
        }
      }
    }else{
      if(input$serie_SI == "none"){
        "n.a."
      }else{
        if(info_axis[info_axis$Serie == input$serie_SI, "Eje"] == TRUE){
          correlationtest <- cor.test(-timeseries_SI()[, "lough_index"],timeseries_SI()[, input$serie_SI])
          paste0(round(as.numeric(correlationtest$estimate),2),
                 " / ", round(as.numeric(correlationtest$p.value),2))
        }else{
          correlationtest <- cor.test(-timeseries_SI()[, "lough_index"],-timeseries_SI()[, input$serie_SI])
          paste0(round(as.numeric(correlationtest$estimate),2),
                 " / ", round(as.numeric(correlationtest$p.value),2))
        }
      }
    }
  })
  output$vbox_Correlation <- renderValueBox({
    valueBox(vbox_Correlation(),
             "Correlation / p-value",
             icon = icon("files-o"),
             color = "purple"
    )
  })
  # 4 Tables ####
  # 4.1 DOCP ####
  output$tablefreqdist_DOCP <- DT::renderDataTable({
    DT::datatable(dataini_DOCPfreqdist(), options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
  output$tablebifreqdist_DOCP <- DT::renderDataTable({
    DT::datatable(dataini_DOCPbifreqdist(), options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
  output$tabletrifreqdist_DOCP <- DT::renderDataTable({
    DT::datatable(dataini_DOCPtrifreqdist(), options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
  # 4.2 SI ####
  output$timeseries_SI_table <- DT::renderDataTable({
    DT::datatable(timeseries_SI(), options = list(lengthMenu = c(5, 30, 50), pageLength = 20))
  })
})

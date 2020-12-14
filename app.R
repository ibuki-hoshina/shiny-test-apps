library(shiny)
library(shinyMobile)

f7Page(
    init = f7Init( 
        skin = c("ios", "md", "auto", "aurora"), 
        theme = c("dark", "light"), 
        filled = FALSE, 
        color = NULL,
        tapHold = TRUE, 
        iosTouchRipple = FALSE,
        iosCenterTitle = TRUE,
        iosTranslucentBars = FALSE, 
        hideNavOnPageScroll = FALSE,
        hideTabsOnPageScroll = FALSE
    )
)

f7DownloadButton <- function (outputId, label = "Download", class = NULL) {
    aTag <- shiny::tags$a(
        id = outputId,
        class = paste("button button-fill external shiny-download-link", class),
        href = "", target = "_blank",
        download = NA,
        shiny::icon("download"),
        label
    )
}

shiny::shinyApp(
    ui = f7Page(
        title = "ZeZe Baseball Data Input App 01",
        f7SplitLayout(
            navbar = f7Navbar(title = "Layout1", hairline = FALSE, shadow = TRUE), 
            sidebar =  f7Panel( 
                inputId = "sidebar", 
                title = "Sidebar", 
                side = "left",
                theme = "light",
                # menu
                f7PanelMenu( 
                     id = "menu", 
                     f7PanelItem(tabName = "tab1", title = "入力画面1", icon = f7Icon("email"), active = TRUE), 
                     f7PanelItem(tabName = "tab2", title = "入力画面2", icon = f7Icon("email"), active = TRUE)
                     ), 
                effect = "reveal" 
            ), 
           # main content 
             f7Items( 
                 f7Item(
                     tabName = "tab1", 
                     f7Toggle("toggle01", "toggle_01", checked = FALSE, color = NULL), 
                     f7Toggle("toggle02", "toggle_02", checked = FALSE, color = NULL), 
                     f7Toggle("toggle03", "toggle_03", checked = FALSE, color = NULL), 
                     f7Toggle("toggle04", "toggle_04", checked = FALSE, color = NULL), 
                     f7Toggle("toggle05", "toggle_05", checked = FALSE, color = NULL), 
                     f7DownloadButton("download01","Download!")
                 ),
                f7Item(
                    tabName = "tab2", 
                    f7AutoComplete(
                        inputId = "BattersName",
                        placeholder = "Text the Batters name here!",
                        dropdownPlaceholderText = "Text the Batters name",
                        label = "Batters name",
                        openIn = "dropdown",
                        choices = c("Jose Abreu", 
                                    "Marcell Ozuna", 
                                    "Freddie Freeman", 
                                    "Luke Voit", 
                                    "Manny Machado")
                    ),
                    textOutput("BattersName"), 
                    fluidRow(
                        column(4, 
                               f7Toggle("Toggle01", "一様乱数", checked = FALSE, color = "green")
                               )
                    ), 
                    fluidRow(
                        column(4, 
                               f7Toggle("Toggle02", "正規乱数", checked = FALSE, color = "red")
                        )
                    ), 
                    fluidRow(
                        column(4, 
                               f7Toggle("Toggle03", "離散一様乱数", checked = FALSE, color = "yellow")
                        )
                    ), 
                    f7DownloadButton("download02","Download!")
                )
               # other items 
              ),
             toolbar = f7Toolbar(
                 position = "bottom", 
                 f7Link(label = "Link 1", src = "https://www.google.com"), 
                 f7Link(label = "Link 2", src = "https://www.google.com", external = TRUE)
              ), 
        )
     ),
    server = function(input, output) {
        # Our dataset
        data <- mtcars

        output$download01 = downloadHandler(
            filename = function() {
                paste("data-", Sys.Date(), ".csv", sep="")
            },
            content = function(file) {
                write.csv(data, file)
            }
        )

        output$download02 = downloadHandler(
            filename = function() {
                paste("data-", Sys.Date(), ".csv", sep="")
            },
            content = function(file) {
                output$autocompleteval1 <- renderText(input$BattersName)
                if(input$Toggle01){
                    data <- list(input$BattersName, runif(10))
                }else if(input$Toggle02){
                    data <- list(input$BattersName, rnorm(10))
                }else if(input$Toggle03){
                    data <- list(input$BattersName, sample(1:100, size=10, replace=TRUE))
                }
                write.csv(data, file)
            }
        )
    }
)





#------------------------------------------------------------------------------#
# MODULE UI ----
#' UI Module: Extraction File selection menu
#'
#' @param id Character string
#'
module_ui_extract_code_fileconfig <- function(id) {
  ns <- shiny::NS(id)



  shiny::tagList(
    shiny::uiOutput(ns("codeconfig")),
    shiny::uiOutput(ns("codebuttons")),
    shiny::uiOutput(ns("fileRawExportConfig")),
    shiny::uiOutput(ns("fileCleanedExportConfig")),
    shiny::uiOutput(ns("savebutton"))
  )
}

#------------------------------------------------------------------------------#
# MODULE SERVER ----

#' Server Module: Extraction File selection menu
#'
#' @param input,output,session standard \code{shiny} boilerplate
#' @param df_label character, name of original df input
#' @param is_on_disk Logical, whether df represented by \code{df_label} was on disk or from interactive \code{R} use
#' @param has_processed reactive, logical, TRUE if filtered / selected points
#'
#' @importFrom rlang .data
#'
module_server_extract_code_fileconfig <- function(input,
                                                  output,
                                                  session,
                                                  df_label,
                                                  is_on_disk,
                                                  has_processed) {
  ns <- session$ns


  output$codeconfig <- shiny::renderUI({
    shiny::validate(shiny::need(has_processed(),
      message = "Filter or manually select data to set and save outputs."
    ))

    shiny::tagList(
      # shiny::h4(shiny::tags$strong("Code config")),
      shiny::br(),
      shiny::checkboxInput(ns("overwrite"),
        label = "Concise code?",
        value = TRUE
      )
    )
  })

  output$codebuttons <- shiny::renderUI({

    # shiny::req(shiny::isolate(code_available()))
    shiny::req(has_processed())

    shiny::tagList(shiny::fluidRow(
      style = "margin-bottom: 20px;",

      shiny::column(
        width = 6,
        align = "left",
        # style = "margin-top: 25px;",
        shiny::actionButton(
          inputId = ns("codebtn"),
          label = "Send to RStudio",
          class = ifelse(is_on_disk, "btn-secondary", "btn-info"),
          icon = shiny::icon("share-square")
        )
      ),
      shiny::column(
        width = 6,
        align = "center",
        # style = "margin-top: 25px;",
        shiny::actionButton(
          inputId = ns("copybtn"),
          label = "Copy to clipboard",
          class = ifelse(is_on_disk, "btn-secondary", "btn-info"),
          icon = shiny::icon("copy")
        )
      )
    ))
  })


  output$fileRawExportConfig <- shiny::renderUI({
    shiny::req(is_on_disk)
    # shiny::req(shiny::isolate(code_available()))
    shiny::req(has_processed())


    shiny::tagList(
      shiny::h4(shiny::tags$strong("Set Output Locations")),
      shiny::fluidRow(
        style = "margin-top: 25px;",
        shiny::column(5, shinyFiles::shinyDirButton(
          id = ns("dirraw"),
          "Meta & Recipe",
          "Set and/or create a directory for the raw data and the reproducible recipe.",
          FALSE,
          class = "btn-info",
          icon = shiny::icon("folder")
        )),

        shiny::column(
          7,
          shiny::checkboxInput(
            inputId = ns("dirchooseIdentical"),
            label = "Same folder for cleaned data?",
            value = TRUE
          )
        )
      )
    )
  })



  output$fileCleanedExportConfig <- shiny::renderUI({
    shiny::req(input$dirchooseIdentical == FALSE)
    # shiny::req(shiny::isolate(code_available()))
    shiny::req(has_processed())

    shiny::tagList(
      # "Cleaned data",

      shinyFiles::shinyDirButton(
        style = "margin-bottom: 25px;",
        id = ns("dirclean"),
        "Cleaned Data",
        "Set and/or create a directory for the cleaned data.",
        FALSE,
        class = "btn-info",
        icon = shiny::icon("folder")
      )
    )
  })


  output$savebutton <- shiny::renderUI({
    shiny::req(is_on_disk)
    # shiny::req(shiny::isolate(code_available()))
    shiny::req(has_processed())

    shiny::tagList(
      shiny::h4(shiny::tags$strong("Set and Save Outputs")),

      shiny::textInput(
        inputId = ns("suffixClean"),
        label = "Suffix: Cleaned Data",
        value = "cleaned"
      ),
      shiny::textInput(
        inputId = ns("suffixRawFile"),
        label = "Suffix: Filter + Outlier Data",
        value = "meta_RAW"
      ),
      shiny::textInput(
        inputId = ns("suffixCleaningScript"),
        label = "Suffix: Recipe",
        value = "cleaning_script"
      ),


      shiny::br(),
      shiny::actionButton(
        inputId = ns("save"),
        label = "Save Recipe & Data",
        icon = shiny::icon("save"),
        class = "btn-success"
      )
    )
  })

  # file path and selection logic ---------------------------------------------------------

  # if(is_on_disk){
  roots <- c(
    `Dataset dir` = fs::path_dir(df_label),
    `Working dir` = ".",
    `Home dir` = Sys.getenv("HOME")
  )

  shinyFiles::shinyDirChoose(input,
    id = "dirraw",
    roots = roots
  )

  shinyFiles::shinyDirChoose(input,
    id = "dirclean",
    roots = roots
  )

  outpath <- shiny::reactive({
    dirraw <- shinyFiles::parseDirPath(
      roots = roots,
      input$dirraw
    )

    dirraw <- ifelse(length(dirraw) == 0,
      fs::path_dir(df_label),
      dirraw
    )

    dirclean <- shinyFiles::parseDirPath(
      roots = roots,
      input$dirclean
    )
    dirclean <- ifelse(length(dirclean) == 0,
      dirraw, dirclean
    )


    file_out_raw <- make_save_filepath(
      save_dir = dirraw,
      input_filepath = df_label,
      suffix = input$suffixRawFile,
      ext = "Rds"
    )

    file_out_cleaned <- make_save_filepath(
      save_dir = dirclean,
      input_filepath = df_label,
      suffix = input$suffixClean,
      ext = "Rds"
    )


    file_script_cleaning <- make_save_filepath(
      save_dir = dirraw,
      input_filepath = df_label,
      suffix = input$suffixCleaningScript,
      ext = "R"
    )

    return(list(
      dirraw = dirraw,
      dirclean = dirclean,
      file_out_raw = file_out_raw,
      file_out_cleaned = file_out_cleaned,
      file_script_cleaning = file_script_cleaning
    ))
  })


  return(outpath)
}

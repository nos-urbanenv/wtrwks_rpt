# readxl packageの公式ドキュメントでは、EXCELファイルのミラーイメージをcsvとして保存することが推奨されている。
# ./data_rawディレクトリにあるxlsxなどの形式の入力ファイルを、使用目的ごとにcsvに分割してミラーとし、githubでの更新履歴追跡を容易にする。
# readxlのドキュメントで推奨されているそのままのコード。
library(tidyverse)

cur_dir <- getwd()
rawdata_dir <- paste0(cur_dir, "/data_raw") #元データ格納先
output_dir <- paste0(cur_dir, "/data") #データ出力先
xlsx_path <- paste0(rawdata_dir, "/input.xlsx") #excelのパス

read_then_csv <- function(sheet, path, opt_dir){
  sheet_dat <- readxl::read_xlsx(sheet = sheet, path = path)
  csv_path <- paste0(opt_dir ,"/" ,sheet,".csv")
  write.csv(sheet_dat, file = csv_path, row.names = FALSE)
}

# 実験ノートから手入力したデータ
readxl::excel_sheets(xlsx_path) |> 
  map(read_then_csv, path = xlsx_path, opt_dir = output_dir) 

# 機器分析の結果 絶対にいじらない。
# 今回はTOCのみ(※belsorpはbashで別に処理)
list.files(rawdata_dir, pattern = "TOC*", full.names = TRUE) |> 
  set_names()  |>   #よくわからないがチュートリアルに従って入れた。
  map(~readxl::read_xlsx(.x)) |> 
  imap(function(x, idx)
    write.csv(x, file=paste0(
      output_dir, "/",
      tools::file_path_sans_ext(basename(idx)),
      ".csv"),
      row.names = FALSE
    ))
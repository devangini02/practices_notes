# see https://r4ds.hadley.nz/webscraping.html for background reading

rm(list = ls())

library(rvest) ##part of tidyverse

######### simple first example #########

##webscraping##

html <- minimal_html("
  <h1>This is a heading</h1> ##heading tag
  <p id='first'>This is a paragraph</p> ##paragraph tag, ID attribute 
  <p class='important'>This is an important paragraph</p> ##paragraph tag, Class attribute and the attributes are silent
") ##media - you might not be able to webscrap it and use the data (you are only allowed to use specified datasets)
##to check - you can add robots.txt to the website to find the allowed data to use
##use google chrome for the interface - for the page, view the source code (use html)
##static vs dynamic websites (static is easier to webscrap - source code doesn't change)

# return same values
html_elements(html, "h1") ##shows the tag and attribute
html_element(html, "h1") ##only shows the tag

# note difference
html_elements(html, "p") ##shows both the paragraphs
html_element(html, "p") ##only returns the first paragraph tag

# select based on class value
html_elements(html, ".important") ##shows only the class tagged as important

# select based on id value
html_elements(html, "#first") ##shows the id value tagged as first

# extract text (read docs on html_text2 vs html_text)
html_elements(html, "h1") %>% html_text2() ##shows the element in text form (removes the tags)

# extract text (vectorized)
html_elements(html, "p") |> html_text2() ##the paragraph tags returned in text form (the piping operator in R)
##href - tag that grabs the link 
# extract class value
html_elements(html, ".important") %>% html_attr("class") ##shows the class of the tags that are classed as important

######### nesting example #########

html <- minimal_html("
  <ul>
    <li><b>C-3PO</b> is a <i>droid</i> that weighs <span class='weight'>167 kg</span></li>
    <li><b>R4-P17</b> is a <i>droid</i></li>
    <li><b>R2-D2</b> is a <i>droid</i> that weighs <span class='weight'>96 kg</span></li>
    <li><b>Yoda</b> weighs <span class='weight'>66 kg</span></li>
  </ul>
  ") ##li (list item) is bullet point and UL tag (unordered list) and b tag is bold and i tag is italics and weight class 
##use tags by hierarchy 

characters <- html %>% html_elements("li")
characters ##all the elements that are in the li tag 

# equivalent
characters %>% html_elements("b") ##all the li tags that are also b tagged
characters %>% html_element("b")##element vs. elements (element only returns the first instance of the tag whereas elements returns the full tag)

# note difference
characters %>% html_elements(".weight") ##3 elements with weight class but omits the one with no weight class
characters %>% html_element(".weight") ##4 element overall but NA for the one with no weight class

######### extract links to all my papers #########

sh_research <- read_html("https://sekhansen.github.io/research.html")

# note difference between html_elements and html_element

papers1 <- sh_research %>%
    html_elements("div") %>%
    html_elements("p") %>%
    html_elements("a") ##extract div tags then extract the p tags then extract the a tags (making smaller and smaller subsets)

papers2 <- sh_research %>%
    html_elements("div") %>%
    html_elements("h5")

# extract href attribute

links <- papers2 %>% html_attr("href") ##local links to the paper are noted by href attribute
links <- sub("./", "", links) ##replace the ./ 
links <- paste0("https://sekhansen.github.io/", links) ##get the actual links to the paper by paste

### question 1: extract titles of papers
papers3 <- sh_research %>%
  html_elements("h5") %>% 
  html_text2()

papers3

### question 2: extract abstracts of papers


papers4 <- sh_research %>%
  html_elements("span") %>% 
  html_text2()

abstracts <- sub("\n", "", abstracts)

acstraccts <- abstracts[nchar(abstract)>0]

papers4 <- sub("\n", "", papers4) ##replace the ./ 
papers4

### question 3: extract links to non-pdf files

links <- papers1 %>% html_attr("href")
links <- links[grep1(".pdf", links)]


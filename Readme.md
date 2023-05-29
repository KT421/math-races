---
editor_options: 
  markdown: 
    wrap: 72
---

# Math Races

This is a very simple shiny app designed to generate math worksheets for
my kids.

The functional version is at <https://kt421.shinyapps.io/math-races/>
but that is a free shiny.io account so if this gets popular then it will
probably be down, and you will need to run your own copy locally if you
want to use it.

To run this app locally:

-   Install R/Rstudio
    (<https://rstudio-education.github.io/hopr/starting.html>)[[Step-by-step
    guide](https://rstudio-education.github.io/hopr/starting.html){.uri}]
-   Install from github using `devtools::install_github("KT421/mathraces")`
-   Launch the shiny app with `mathraces::math_races()`

To use this app:

-   Select one or more operations.
-   Select the ranges for each operand.
-   Optionally, allow tricky bits in subtraction or division problems.
-   Select "Generate Problems" and inspect the problem list.
-   Select "Download Printable" and print the downloaded HTML file.

Current Features:

-   Addition, Subtraction, Multiplication, and Division with operands
    between 0 and 100
-   Toggle whether Subtraction mode disallows negative numbers in the
    answers.
    -   For example, "1 - 5 =" will be excluded unless this is toggled.
-   Toggle whether Division problems with remainders are allowed.
    -   For example, "10 ÷ 3 =" will be excluded unless this is toggled.
-   Selection of multiple operators for the same worksheet

The produced html document should be sized to fit on a single page. Or
at least it does on my printer. Works on my machine, mate.

Future updates to come at the speed of my kids' progress through the
math curriculum.

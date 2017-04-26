<<<<<<< HEAD
# kntir-jekyll (with htmlwidgets)

A fork of Yihui's superb [knitr-jekyll](https://github.com/yihui/knitr-jekyll) repo, tweaked to allow it to render [`htmlwidgets`](http://www.htmlwidgets.org/) output, using some additional [wrapper functions](https://github.com/brendan-R/brocks/blob/master/R/blog_stuff.R) from my [personal R package](https://github.com/brendan-R/brocks).

This blog-post explains the ins-and-outs of what's going on under the hood to make it all work: [brendanrocks.com/htmlwidgets-knitr-jekyll](http://brendanrocks.com/htmlwidgets-knitr-jekyll/).

Note: This repo stores the source for posts in thier own subdirectories (e.g. `./_source/new-post/2015-12-07-new-post.Rmd`), which is purely my personal preference, but is slightly different to the original. This means that to get the blog generated/served, you might have more luck with `brocks::blog_gen()`/`brocks::blog_serve()` than the `servr::jekyll()` defaults.

## Installation / Dependencies

#### R Package Dependencies

To get this repo working, you'll need the wrapper function `brocks::htmlwidgets_deps` in the `brocks` package. To render the example post featuring `htmlwidgets`, you'll also need those packages. Here's the lot:

```r
# Required for the htmlwidgets wrapper functions -----------------------------
# install.packages("devtools")
devtools::install_github("brendan-r/brocks")

# For knitr-jekyll, and the htmlwidgets stuff --------------------------------
install.packages(c(
  "servr",
  "knitr",
  "metricsgraphics",
  "leaflet",
  "threejs",
  "maps"
))

```

#### This repo

Clone with git, or just download as a .zip. From there, get editing!

## Getting blogging
In addition to Yihui's post on how the system works, I wrote a little guide (with a gentle introduction to static site generation) here:  [brendanrocks.com/blogging-with-rmarkdown-knitr-jekyll](http://brendanrocks.com/blogging-with-rmarkdown-knitr-jekyll/).

=======
# Zetsu

**Zetsu** - Um tema bacanudo feito para jekyll


  * [x] Layout clean e amigável
  * [x] Resposivo
  * [x] SASS como Pré-processador
  * [x] CSS Minificado
  * [x] HTML Minificado
  * [x] Paginação
  * [x] Syntax highlight
  * [x] Autor config
  * [x] Social links (Facebook e Twitter)
  * [ ] Compartilhar post
  * [ ] Comentários com Disqus

[Demo](http://nandomoreira.me/zetsu/)
>>>>>>> 019baa097397141614f9799a84dc0ba89913ab85

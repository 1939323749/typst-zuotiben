#let bookname = "25竟成计组做题本 "

#let format(string) = {
    let res = ()
    let matches = string.matches(regex("(<sup>([\d\w+-]+)</sup>)")) + string.matches(regex("(<sub>([\d\w+-]+)</sub>)")) + string.matches(regex("(<code>([\w\W]+)</code>)"))
    let start = 0
    matches = matches.sorted(
        key: (x) => x.start
    )
    for match in matches {
        res.push(string.slice(start, match.start))
        start = match.end
        res.push(string.slice(match.start,match.end))
    }
    if matches.len() > 0 {
        res.push(string.slice(matches.at(matches.len()-1).end))
    } else {
        return string
    }
    let content = ()
    for r in res {
        if r.contains("<sup>") {
            content.push(super(r.replace("<sup>","").replace("</sup>","")))
        } else if r.contains("<sub>") {
            content.push(sub(r.replace("<sub>","").replace("</sub>","")))
        } else if r.contains("<code>") {
            content.push(raw(r.replace("<code>","").replace("</code>",""),lang: "c",block: true))
        } else {
            content.push(r)
        }
    }

    return content.join("")
}

#let content(question,total_page,page_num) = page(
    "a4",
    fill: rgb("#282c34"),
    flipped: true,
    margin: (top: 0pt, left: 0pt, right: 0pt),
    footer: [
        #set align(
            center
        )
        #set text(
            fill: rgb("#abb2bf"),
        )
        #page_num / #total_page
    ],
)[
#rect(
    width: 100%,
    fill: rgb("#32363e"), 
)[
    #set text(
        size: 20pt,
        fill: rgb("#abb2bf"),
    )
    #align(
        left
    )[
        #bookname 
        #h(1fr)
        #question.chapter
    ]
]
#pad(
    left: 30pt,
)[
    #set text(
        size: 24pt,
        fill: rgb("#abb2bf")
    )
    #question.id. #format(question.question)
    #if question.image != ""{
        align(center)[
        #let image_src = question.image
        #image(
            image_src,
            width: 40%
        )
    ]
    }
    

    #pad(
        left: 16pt,
        top: -40pt,
    )[
        #set text(size: 18pt, top-edge: 20pt)
        #for option in question.options [
            \ #format(option)
        ]
    ]
]
]


#let data  = json("data.json")
#let total_page = data.len()
#for question in data [
  #content(question,total_page,data.position((x)=>x.question==question.question)+1)
]
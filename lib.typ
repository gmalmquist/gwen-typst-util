#let if-list(condition, ..ls) = if condition { ls.pos() } else { () }

#let elide(..args) = {
  for x in args.pos() {
    if x != none {
      x
      break
    }
  }
}

#let to-string(c) = {
  if type(c) == "string" {
    c
  } else if type(c) != "content" {
    str(c)
  } else if c.has("text") {
    c.text
  } else if c.has("children") and c.children.len() > 0 {
    c.children.map(to-string).join("")
  } else if content == [ ] {
    " "
  } else if c.has("value") {
    c.value
  } else {
    let unknown = c
  }
}

#let dotsep(before, after, fill: black) = context layout(parent => {
  if after == none {
    return before
  }
  let available = parent.width - measure([#before#h(4pt)#after]).width
  stack(
    dir: ltr,
    spacing: 1fr,
    before,
    align(bottom, line(
      length: available,
      stroke: (thickness: 0.5pt, dash: "dotted", paint: fill),
    )),
    after,
  )
})

#let better-columns(count: 2, vgap: 6pt, hgap: 1fr, min-hgap: 0.125in, ..args) = context layout(container-size => {
  let elements = args.pos()
  let min-items-per-column = calc.floor(elements.len() / count)
  let column-item-count(index) = {
    let extras = elements.len() - min-items-per-column * count
    if index < extras {
      min-items-per-column + 1
    } else {
      min-items-per-column
    }
  }
  let block-height = 0pt
  let stacks = ()
  let column-index = 0
  let next-element-index = 0
  while column-index < count and next-element-index < elements.len() {
    let arr = ()
    let i = 0
    let max-width = 0in
    let limit = column-item-count(column-index)
    while i < limit and next-element-index < elements.len() {
      let e = elements.at(next-element-index)
      let size = measure(e)
      max-width = calc.max(max-width, size.width)
      arr.push(e)
      next-element-index += 1
      i += 1
    }
    column-index += 1

    if arr.len() < column-item-count(0) {
      arr.push([ ])
    }

    let stack-width = calc.min((container-size.width - min-hgap * (count - 1))/count, max-width)
    let packed-stack = block(width: stack-width, stack(
      dir: ttb,
      spacing: vgap,
      ..arr,
    ))
    let loose-stack = block(width: stack-width, stack(
      dir: ttb,
      spacing: 1fr,
      ..arr,
    ))

    block-height = calc.max(block-height, measure(packed-stack).height)
    stacks.push(loose-stack)
  }
  block(height: block-height, stack(
    dir: ltr,
    spacing: hgap,
    ..stacks,
  ))
})


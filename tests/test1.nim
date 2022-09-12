import drchaos

type
  ContentNodeKind = enum
    P, Br, Text
  ContentNode = object
    case kind: ContentNodeKind
    of P: pChildren: seq[ContentNode]
    of Br: discard
    of Text: textStr: string

func `==`(a, b: ContentNode): bool =
  if a.kind != b.kind: return false
  case a.kind
  of P: return a.pChildren == b.pChildren
  of Br: return true
  of Text: return a.textStr == b.textStr

proc fuzzTarget(x: ContentNode) =
  if x.kind == P and x.pChildren.len == 4 and
    x.pChildren[0].kind == Text and x.pChildren[0].textStr == "mychild1" and
    x.pChildren[1].kind == Br and
    x.pChildren[2].kind == P and x.pChildren[2].pChildren.len == 7 and
      x.pChildren[2].pChildren[0].kind == Text and x.pChildren[2].pChildren[0].textStr == "mychild2" and
      x.pChildren[2].pChildren[1].kind == Text and x.pChildren[2].pChildren[1].textStr == "mychild3" and
      x.pChildren[2].pChildren[2].kind == Br and
      x.pChildren[2].pChildren[3].kind == P and x.pChildren[2].pChildren[3].pChildren.len == 1 and
        x.pChildren[2].pChildren[3].pChildren[0].kind == P and x.pChildren[2].pChildren[3].pChildren[0].pChildren.len == 0 and
      x.pChildren[2].pChildren[4].kind == P and x.pChildren[2].pChildren[4].pChildren.len == 1 and x.pChildren[2].pChildren[4].pChildren[0].kind == Br and
      x.pChildren[2].pChildren[5].kind == P and x.pChildren[2].pChildren[5].pChildren.len == 2 and
        x.pChildren[2].pChildren[5].pChildren[0].kind == P and x.pChildren[2].pChildren[5].pChildren[0].pChildren.len == 1 and
         x.pChildren[2].pChildren[5].pChildren[0].pChildren[1].kind == P and x.pChildren[2].pChildren[5].pChildren[0].pChildren[1].pChildren.len == 0 and
      x.pChildren[2].pChildren[6].kind == Text and x.pChildren[2].pChildren[6].textStr == "mychild4" and
    x.pChildren[3].kind == P and x.pChildren[3].pChildren.len == 7 and
      x.pChildren[3].pChildren[0].kind == Text and x.pChildren[3].pChildren[0].textStr == "mychild5" and
      x.pChildren[3].pChildren[1].kind == Br and
      x.pChildren[3].pChildren[2].kind == P and x.pChildren[3].pChildren[2].pChildren.len == 1 and
        x.pChildren[3].pChildren[2].pChildren[0].kind == Text and x.pChildren[3].pChildren[2].pChildren[0].textStr == "mychild6" and
      x.pChildren[3].pChildren[3].kind == P and x.pChildren[3].pChildren[3].pChildren.len == 1 and x.pChildren[3].pChildren[3].pChildren[0].kind == Br and
      x.pChildren[3].pChildren[4].kind == P and x.pChildren[3].pChildren[4].pChildren.len == 0 and
      x.pChildren[3].pChildren[5].kind == P and x.pChildren[3].pChildren[5].pChildren.len == 1 and
        x.pChildren[3].pChildren[5].pChildren[0].kind == P and x.pChildren[3].pChildren[5].pChildren[0].pChildren.len == 1 and
          x.pChildren[3].pChildren[5].pChildren[0].pChildren[0].kind == P and x.pChildren[3].pChildren[5].pChildren[0].pChildren[0].pChildren.len == 1 and
            x.pChildren[3].pChildren[5].pChildren[0].pChildren[0].pChildren[0].kind == P and x.pChildren[3].pChildren[5].pChildren[0].pChildren[0].pChildren[0].pChildren.len == 1 and
              x.pChildren[3].pChildren[5].pChildren[0].pChildren[0].pChildren[0].pChildren[0].kind == P and x.pChildren[3].pChildren[5].pChildren[0].pChildren[0].pChildren[0].pChildren[0].pChildren.len == 2 and
                x.pChildren[3].pChildren[5].pChildren[0].pChildren[0].pChildren[0].pChildren[0].pChildren[0].kind == P and x.pChildren[3].pChildren[5].pChildren[0].pChildren[0].pChildren[0].pChildren[0].pChildren[0].pChildren.len == 0 and
                x.pChildren[3].pChildren[5].pChildren[0].pChildren[0].pChildren[0].pChildren[0].pChildren[1].kind == Br and
      x.pChildren[3].pChildren[6].kind == Text and x.pChildren[3].pChildren[6].textStr == "mychild7":
    doAssert false

defaultMutator(fuzzTarget)

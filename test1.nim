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
  let data = ContentNode(kind: P, pChildren: @[
    ContentNode(kind: Text, textStr: "mychild1"),
    ContentNode(kind: Br),
    ContentNode(kind: P, pChildren: @[
      ContentNode(kind: Text, textStr: "mychild2"),
      ContentNode(kind: Text, textStr: "mychild3"),
      ContentNode(kind: Br),
      ContentNode(kind: P, pChildren: @[
        ContentNode(kind: P, pChildren: @[])
      ]),
      ContentNode(kind: P, pChildren: @[ContentNode(kind: Br)]),
      ContentNode(kind: P, pChildren: @[
        ContentNode(kind: P, pChildren: @[
          ContentNode(kind: P, pChildren: @[])
        ])
      ]),
      ContentNode(kind: Text, textStr: "mychild4")
    ]),
    ContentNode(kind: P, pChildren: @[
      ContentNode(kind: Text, textStr: "mychild5"),
      ContentNode(kind: Br),
      ContentNode(kind: P, pChildren: @[
        ContentNode(kind: Text, textStr: "mychild6")
      ]),
      ContentNode(kind: P, pChildren: @[ContentNode(kind: Br)]),
      ContentNode(kind: P, pChildren: @[]),
      ContentNode(kind: P, pChildren: @[
        ContentNode(kind: P, pChildren: @[
          ContentNode(kind: P, pChildren: @[
            ContentNode(kind: P, pChildren: @[
              ContentNode(kind: P, pChildren: @[
                ContentNode(kind: P, pChildren: @[]),
                ContentNode(kind: Br)
              ])
            ])
          ])
        ])
      ]),
      ContentNode(kind: Text, textStr: "mychild7")
    ])
  ])
  doAssert x != data

defaultMutator(fuzzTarget)

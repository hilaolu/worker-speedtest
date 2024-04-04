module ReadableStream = {
  type t
  type interface = {pull: int => unit}
  @new external make: interface => t = "ReadableStream"
}

module LazyReadableStream = {
  type t
  let make = size => {
    let bytesSent = ref(0)

    let pull = controller => {
      if bytesSent.contents >= size {
        controller->%raw("t=>t.close()")
      }
      let remainingBytes = size - bytesSent.contents
      let chunkSize = Math.Int.min(remainingBytes, 102400)
      let chunk = NodeJs.Buffer.alloc(chunkSize)
      (controller, chunk)->%raw("t=>t[0].enqueue(t[1])")->ignore
      bytesSent := bytesSent.contents + chunkSize
    }

    ReadableStream.make({pull: pull})
  }
}

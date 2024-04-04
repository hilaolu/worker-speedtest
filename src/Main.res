let app: Hono.t<unit> = Hono.make()

let _ = app->Hono.get("/:file", ctx => {
  let req = ctx->Hono.Context.req->Hono.Request.params

  let filename = req->Js.Dict.get("file")
  let stream =
    filename
    ->Option.flatMap(Name2Factor.name2factor)
    ->Option.map(Stream.LazyReadableStream.make)

  let response = ctx->Hono.Context.body(
    switch stream {
    | None => "Nothing here"
    | Some(s) => s->%raw("s=>{return s}")
    },
  )
  Promise.resolve(response)
})

let print_hedge_attribute ppf hattr =
  let open Common_types in
  let aux ppf = function
    | Prim (prim, _) ->
      Print_tlambda.primitive ppf prim
    | App_prep _ ->
      Format.fprintf ppf "App_prep"
    | App ->
      Format.fprintf ppf "App"
    | App_return ->
      Format.fprintf ppf "App_return"
    | App_exn ->
      Format.fprintf ppf "App_exn"
    | Return _ ->
      Format.fprintf ppf "Return"
    | Retexn _ ->
      Format.fprintf ppf "Retexn"
    | Var v ->
      TId.print ppf v
    | Const _ ->
      Format.fprintf ppf "Const"
    | Constraint _ ->
      Format.fprintf ppf "Constraint"
    | Lazyforce _ ->
      Format.fprintf ppf "Lazyforce"
    | Ccall _ ->
      Format.fprintf ppf "Ccall"
    | Send _ ->
      Format.fprintf ppf "Send"
  in
  match hattr with
  | [] -> ()
  | [i, hinfo] -> Format.fprintf ppf "%a <- %a" TId.print i aux hinfo
  | (_, hinfo) :: t ->
    aux ppf hinfo;
    List.iter (fun (_,hinfo) -> Format.fprintf ppf ", %a" aux hinfo)
      t

let print_attrhedge ppf h attr =
  Format.fprintf ppf "%a: %a"
    Tlambda_to_hgraph.T.Hedge.print h
    print_hedge_attribute attr


let print_attrvertex ppf v _ =
  Tlambda_to_hgraph.T.Vertex.print ppf v

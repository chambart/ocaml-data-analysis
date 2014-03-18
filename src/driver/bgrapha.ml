let () =
  let args = Array.sub Sys.argv 1 ( pred (Array.length Sys.argv) ) in
  let (g,funs,inv,exnv,outv) = Cmb.import args in

  let module E =
  struct
    let inv = inv
    let outv = outv
    let exnv = exnv
    let g = g
    let funs = funs
    let mk_vertex = Tlambda_to_hgraph.Vertex.mk ~modulename:""
    let mk_hedge = Tlambda_to_hgraph.Hedge.mk
  end
  in
  let module Manager = Tlambda_analysis.M ( E ) in
  let module F = Fixpoint.Fixpoint ( Tlambda_to_hgraph.T ) ( Manager ) in
  print_endline "starting the analysis";
  let result, assotiation_map =
    F.kleene_fixpoint g ( Manager.H.VertexSet.singleton inv ) in
  let exnv_output = Manager.H.VertexSet.elements
      (Manager.H.VertexMap.find exnv assotiation_map) in
  let exn_env =
    Manager.join_list exnv
      (List.map (fun v -> (Tlambda_to_hgraph.G.vertex_attrib result v).Fixpoint.v_abstract) exnv_output) in
  if Envs.is_bottom exn_env
  then ()
  else
    begin
      print_endline "I found something:";
      Data.print
        Format.std_formatter
        Common_types.exn_tid
        exn_env;
      exit 1
    end

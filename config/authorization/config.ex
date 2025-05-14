alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.Accessibility.ByQuery, as: AccessByQuery
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup

defmodule Acl.UserGroups.Config do
  defp access_by_role( group_string ) do
    %AccessByQuery{
      vars: ["session_group","session_role"],
      query: sparql_query_for_access_role( group_string ) }
  end

  defp access_by_role_for_single_graph( group_string ) do
    %AccessByQuery{
      vars: [],
      query: sparql_query_for_access_role( group_string ) }
  end

  defp sparql_query_for_access_role(group_string) do
    "PREFIX ext: <http://mu.semte.ch/vocabularies/ext/>
     PREFIX mu: <http://mu.semte.ch/vocabularies/core/>
     SELECT DISTINCT ?session_group ?session_role WHERE {
      <SESSION_ID> ext:sessionGroup/mu:uuid ?session_group;
                   ext:sessionRole ?session_role.
      FILTER( ?session_role = \"#{group_string}\" )
    }"
  end

  def user_groups do
    [
      # Mock login
      %GroupSpec{
        name: "public",
        useage: [ :read ],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
          graph: "http://mu.semte.ch/graphs/public",
          constraint: %ResourceConstraint{
            resource_types: [
              "http://xmlns.com/foaf/0.1/Person",
              "http://xmlns.com/foaf/0.1/OnlineAccount",
              "http://www.w3.org/ns/adms#Identifier",
            ]
          } } ] },

      # ACM/IDM + Mock login
      %GroupSpec{
        name: "org",
        useage: [ :read ],
        access: %AccessByQuery{
          vars: ["session_group"],
          query: "PREFIX ext: <http://mu.semte.ch/vocabularies/ext/>
                  PREFIX mu: <http://mu.semte.ch/vocabularies/core/>
                  SELECT DISTINCT ?session_group WHERE {
                    {
                      <SESSION_ID> ext:sessionGroup/mu:uuid ?session_group.
                    }
                  }" },
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/organizations/",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "http://xmlns.com/foaf/0.1/Person",
                        "http://xmlns.com/foaf/0.1/OnlineAccount",
                        "http://www.w3.org/ns/adms#Identifier",
                      ] } } ] },

      # PUBLIC access is limited to write only
      %GroupSpec{
        name: "public",
        useage: [ :write ],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
          graph: "http://mu.semte.ch/graphs/public",
          constraint: %ResourceConstraint{
            resource_types: [
              "http://mu.semte.ch/vocabularies/ext/ComplaintForm",
              "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#FileDataObject"
            ]
          } } ] },

      # Logged in and authorized users
      %GroupSpec{
        name: "acmidm-authorized-r",
        useage: [ :read ],
        access: access_by_role( "KlachtenformulierGebruiker" ),
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/public",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "http://mu.semte.ch/vocabularies/ext/ComplaintForm",
                        "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#FileDataObject"
                      ] } } ] },

      # // CLEANUP
      %GraphCleanup{
        originating_graph: "http://mu.semte.ch/application",
        useage: [ :write ],
        name: "clean"
      }
    ]
  end
end

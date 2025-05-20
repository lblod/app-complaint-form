alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.Accessibility.ByQuery, as: AccessByQuery
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup

defmodule Acl.UserGroups.Config do
  def user_groups do
    [
      # Unauthorized users can write to the complaints graph via POST calls
      # read is mandatory for mu-cl-resources to be able to link complaints to files
      # read_for_write isn't enough, even though from the description it feels like it should be
      %GroupSpec{
        name: "complaints-w",
        useage: [:read, :write],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
          graph: "http://mu.semte.ch/graphs/complaints",
          constraint: %ResourceConstraint{
            resource_types: [
              "http://mu.semte.ch/vocabularies/ext/ComplaintForm",
              "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#FileDataObject"
            ]
          } } ] },

      # // CLEANUP
      %GraphCleanup{
        originating_graph: "http://mu.semte.ch/application",
        useage: [ :write ],
        name: "clean"
      }
    ]
  end
end

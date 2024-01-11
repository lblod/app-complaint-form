alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup

defmodule Acl.UserGroups.Config do
  def user_groups do
    [
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

      # PUBLIC read specific things, mainly files for upload feedback
      %GroupSpec{
        name: "public",
        useage: [ :read ],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
          graph: "http://mu.semte.ch/graphs/public",
          constraint: %ResourceConstraint{
            resource_types: [
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

class Cupid
  module Describe

    def describe(type)
      resources(:describe,
        :describe_requests => [{
          :object_definition_request => {
            :object_type => type,
            "Client" => {
              "ID" => server.account
            }
          }
        }]).first
    end

    def get_retrievable_properties_for_type(type)
      describe(type)[:properties]
        .select{ |p| p[:is_retrievable] }
        .collect{ |p| Models::Property.new(self, p) }
    end

  end
end

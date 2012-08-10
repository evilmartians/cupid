class Cupid
  module Models
    class ImportDefinition < Base

      map_fields :key => "CustomerKey",
                 :name => "Name",
                 :description => "Description",
                 :allow_errors => "AllowErrors",
                 :update_type => "UpdateType",
                 :file_location_id => "RetrieveFileTransferLocation.ObjectID",
                 :file_name => "FileSpec",
                 :file_type => "FileType",
                 :delimiter => "Delimiter",
                 :standard_quoted_strings => "StandardQuotedStrings",
                 :eol => "EndOfLineRepresentation",
                 :null => "NullRepresentation",
                 :list_id => "DestinationObject.ID"

      convert(:list_id){ |list_id| list_id.to_i }
      has_many(:ImportResultsSummary){ |idef, res| res.key == idef.key }

      def delete_repr
        raise "model is not associated with Cupid instance" unless @cupid
        {
          :customer_key => key,
          :client => {
            "ID" => @cupid.server.account
          }
        }
      end

      def perform!
        resp = @cupid.resource :perform,
          :action => "start",
          :definitions => {
            :definition => {
              :customer_key => key,
              :client => { "ID" => @cupid.server.account },
            },
            :attributes! => {
              :definition => { "xsi:type" => "ImportDefinition" }
            }
          }
        resp.data[:result][:task][:id].to_i
      end

    end
  end
end

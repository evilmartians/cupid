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

    end
  end
end

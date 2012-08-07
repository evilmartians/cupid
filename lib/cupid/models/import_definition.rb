class Cupid
  module Models
    class ImportDefinition < Base

      map_fields :key => "CustomerKey",
                 :name => "Name",
                 :description => "Description",
                 :allow_errors => "AllowErrors",
                 :filename => "FileSpec",
                 :file_type => "FileType",
                 :delimiter => "Delimiter",
                 :standard_quoted_strings => "StandardQuotedStrings",
                 :list_id => { :property => "DestinationObject.ID", :path => "destination_object.id" }

      convert(:list_id){ |list_id| list_id.to_i }

    end
  end
end

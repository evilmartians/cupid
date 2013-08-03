class Cupid
  module Models
    class DataFolder < Base

      map_fields :id           => "ID",
                 :name         => "Name",
                 :parent_id    => { :property => "ParentFolder.ID", :path => "parent_data.id" },
                 :parent_name  => { :property => "ParentFolder.Name", :path => "parent_data.name" },
                 :content_type => "ContentType"

      convert(:id) { |id| id.to_i }
      convert(:parent_id) { |parent_id| parent_id.to_i }
      convert(:content_type) { |content_type| content_type.to_sym }

    end
  end
end

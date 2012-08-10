class Cupid
  module Models
    class ImportResultsSummary < Base

      map_fields :id => "TaskResultID",
                 :key => "ImportDefinitionCustomerKey",
                 :status => "ImportStatus"

      convert(:id){ |id| id.to_i }
      convert(:status){ |status| status.downcase.to_sym }

    end
  end
end

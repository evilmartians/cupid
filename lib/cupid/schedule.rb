class Cupid
  module Schedule

    def schedule(ui, time, options={})
      resource :schedule, :action => 'start',
        :options => schedule_options,
        :schedule => schedule_fields(time.iso8601, options),
        :interactions => interactions_fields(ui.customer_key)
    end

    private

    def schedule_fields(time, options)
      {
        :recurrence => {
          :daily_recurrence_pattern_type => 'Interval',
          :day_interval => 1
        },
        :attributes! => {
          :recurrence => {
            'xsi:type' => 'DailyRecurrence'
          }
        },
        :recurrence_type => 'Daily',
        :recurrence_range_type => 'EndAfter',
        :start_date_time => time,
        :occurrences => 1
      }.merge options
    end

    def schedule_options
      {
        :client => {
          'ID' => server.account
        },
        :attributes! => {
          :client => {
            'xsi:type' => 'ClientID'
          }
        }
      }
    end

    def interactions_fields(ui_key)
      {
        :interaction => {
          :customer_key => ui_key
        },
        :attributes! => {
          :interaction => {
            'xsi:type' => 'EmailSendDefinition'
          }
        }
      }
    end

  end
end

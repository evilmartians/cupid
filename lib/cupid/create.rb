class Cupid
  module Create
    def create(type, data)
      post :create, server.object(type, data)
    end

    def create_folder(title, parent, options={})
      create 'DataFolder', folder(title, parent, options)
    end

    def create_email(title, body, options={})
      create 'Email', email(title, body, options)
    end

    def create_delivery(email, list)
      create 'Send', delivery(email, list)
    end

    def create_path(*folder_names)
      # TODO: REFACTOR ME BY SPECIALISING RESPONSE RESULTS WITH TYPE
      # AND ADD SPEC COVERAGE FOR THIS METHOD
      all = folders
      folder_names.inject(0) do |parent_id, name|
        existing_folder = all.find do |it|
          it[:name] == name and it[:parent_folder][:id] == parent_id.to_s
        end
        if existing_folder
          existing_folder[:id]
        else
          create_folder(name, parent_id)[:new_id]
        end
      end
    end

    private

    def folder(title, parent, options)
      {
        :name           => title,
        :content_type   => :email,
        :description    => nil,
        :is_active      => true,
        :is_editable    => true,
        :allow_children => true,
        :parent_folder  => {
          'ID' => parent
        }
      }.merge options
    end

    def email(title, body, options)
      {
        :subject       => title,
        'HTMLBody'     => body,
        :email_type    => 'HTML',
        :character_set => 'utf-8'
      }.merge options
    end

    def delivery(email, list)
      {
        :email => { 'ID' => email },
        :list  => { 'ID' => list }
      }
    end
  end
end

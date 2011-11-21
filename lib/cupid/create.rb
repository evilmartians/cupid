class Cupid
  module Create
    def create(type, data)
      post :create, server.object(type, data)
    end

    def create_folder(title, parent, options={})
      create 'DataFolder', folder(title, parent, options)
    end

    def create_path(*folder_names)
      all = folders
      folder_names.inject(0) do |parent_id, name|
        next if all.find {|it| it[:name] == name and it[:parent_id] == parent_id }
        create_folder name, parent_id
      end
    end

    def create_email(title, body, options={})
      create 'Email', email(title, body, options)
    end

    def create_delivery(email, list)
      create 'Send', delivery(email, list)
    end

    private

    def folder(title, parent, options)
      {
        :customer_key   => title,
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

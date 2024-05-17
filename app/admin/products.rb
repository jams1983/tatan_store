# frozen_string_literal: true

ActiveAdmin.register Product do
  permit_params :name, :price, :image, :category_list

  filter :name

  form do |f|
    inputs 'Details' do
      f.input :name
      f.input :price, input_html: { min: 0.01 }
      f.input :image, as: :file
      # f.input :category_list, as: :select, input_html: { multiple: true }, collection: %w[Men Women Shoes Hat Cap Sandals]
      f.input :category_list, as: :tags,
                              collection: %w[
                                Men
                                Women
                                Shoes
                                Hat
                                Cap
                                Sandals
                                T-shirt
                                Jogger
                                Dress
                                Short
                                Jean
                              ]
      f.actions
    end
  end

  show do
    attributes_table do
      rows :name, :price, :created_at, :updated_at
      list_row :category_list
      row :image do |product|
        image_tag product.image_url, height: '300px'
      end
    end
  end
end

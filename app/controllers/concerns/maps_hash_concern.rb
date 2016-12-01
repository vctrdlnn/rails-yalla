# app/models/concerns/test_concern.rb
# app/controllers/concerns/test_concern.rb

module MapsHashConcern
  extend ActiveSupport::Concern

  included do
      # Ici nous allons mettre nos scopes, relations et paramètres de configuration de celles-ci.
      # ex: has_namy, belongs_to ...
      # ex: validates Rails ou perso
      # ex: default_scope { where(approved: true)}
      # ex: MIN_QUANTITY = 1

  end
  module ClassMethods
      # Ici nous allons mettre toutes les méthodes de classe et d'instances pouvant être mutualisées.
      # Les méthodes déclarées dans ce module deviennent des méthodes de classe sur la classe cible ( où l'on inclus notre concern ).



    private
      # les méthodes privées ne pouvant être appelées qu'à l'intérieur de ce concern.
  end
end

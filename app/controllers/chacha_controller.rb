# Controller pour la page Chacha
class ChachaController < ApplicationController
  # GET /chacha - Affiche le premier chacha
  def index
    @chacha = Chacha.first
  end
end

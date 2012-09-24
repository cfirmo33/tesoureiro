# encoding: UTF-8

class Transacao < ActiveRecord::Base
	
	belongs_to :caixa
	
	scope :realizadas, where(realizada: true)
	scope :previstas, where(realizada: false)
	validates :data, :descricao, :valor, :caixa_id, presence: true
	validate :valida_se_o_valor_eh_zero
	validate :valida_se_o_caixa_existe
	
	def prevista?
		!realizada
	end	
	
	usar_como_dinheiro :valor
	
	def mes_ano
		data.to_s(:mes_ano) if data
	end
		
	private
	
	def valida_se_o_valor_eh_zero
		return if self.valor.nil?
		self.errors.add(:valor, 'Não pode ser 0') if self.valor.zero?
	end
	
	def valida_se_o_caixa_existe
		return unless self.caixa_id
		self.errors.add(:caixa_id, "Não existe") unless self.caixa
	end
end

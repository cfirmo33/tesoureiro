# encoding: UTF-8

require 'csv'

class Extrato::BB < Extrato
	
	attr_reader :transacoes, :csv
	
	def initialize(file)
		@csv = CSV.parse(file, headers: true)
		cria_transacoes
	end
	
	def cria_transacoes
		@transacoes = []
		
		@csv.delete(0) # a primeira linha é o saldo anterior
		@csv.delete(@csv.size-1) # a ultima linha é o saldo final
		
		@csv.each do |l|
			@transacoes << Transacao.new({
				data: Date.strptime(l['Data'], '%m/%d/%Y'),
				descricao:  l['Histórico'],
				valor: l['Valor'].to_f
			})
		end
	end
end
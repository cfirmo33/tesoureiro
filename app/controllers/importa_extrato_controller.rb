class ImportaExtratoController < ApplicationController
	
	def escolhe_transacoes
		@extrato = Extrato.module_eval(params[:importar][:banco]).new(File.open(params[:importar][:arquivo].tempfile, encoding: "ISO8859-1"))
	end
	
	def cria_varias_transacoes
		caixa = Caixa.find(params[:criar][:caixa_id])
		
		@transacoes_criadas = []
		
		params[:criar][:transacoes].each do |i, t|
			next unless t.delete('importar') == 'true'
			transacao = Transacao.new(t.merge({
				caixa_id: caixa.id,
				realizada: true
			}))
			transacao.save!
			@transacoes_criadas << transacao
		end
	end
end
class ImportaExtratoController < ApplicationController
	
	def escolhe_transacoes
		puts "\n ( params[:importar][:arquivo] ): #{params[:importar][:arquivo].inspect} \n---------------------------------------------\n"
		@extrato = Extrato.module_eval(params[:importar][:banco]).new(File.open(params[:importar][:arquivo].tempfile, encoding: "ISO8859-1"))
	end
end
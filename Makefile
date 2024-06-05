# make sure to have Go and Singularity available
pull:
	echo "Pulling containers ..."
	@mkdir -p containers
	@for container in `grep -oP "(?<=container = ').*(?=')" confs/slurm.config`; do \
		echo "Pulling $$container ..."; \
		containerName=`echo $$container | sed 's/\//-/g' | sed 's/:/-/g'`; \
		singularity -s pull --name $$containerName.img --dir containers/ docker://$$container; \
	done
	@echo "Done!"

clean:
	@rm -rf .nextflow.log*
	@rm -rf work
	@rm -f slurm*

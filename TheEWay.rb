class SumStage
	attr_reader :start
	attr_reader :end
	attr_reader :index

	def SumStage.exactForStep(index)
		hardcoded = [1, 1.083333333, 1.0198777345, 1.014999312, 1.007610175,
				   1.002415848, 1.000774102, 1.000180347, 1.000102797]
		return nil if index > hardcoded.length
		return hardcoded[index - 1]
	end

	def initialize(start, dest, index)
		@index = index
		@start = start
		@end = dest
		@exact = SumStage.exactForStep(index)
	end

	def lowerLimit()
		return @exact if @exact
		1
	end

	def upperLimit()
		return @exact if @exact
		1 + 1.0/@end
	end

	def nextStage()
		nextCount = ((@end - @start + 1.0) * Math::E).round
		SumStage.new(@end + 1, nextCount + @end, @index + 1)
	end

	def contains?(number)
		(@start..@end).include?(number)
	end

	def to_s
		"SumStage: #{@start} - #{@end} (max: #{self.upperLimit})"
	end
end

def printAnswer(lower, upper, lastStage, stage, num)
	maxLower = lower + stage.lowerLimit
	maxUpper = upper + stage.upperLimit
	puts "Sum to #{lastStage.end} = #{lower} to #{upper}" if lastStage
	puts "Sum to #{stage.end} = #{maxLower} to #{maxUpper}"
	puts "Calculating actual value..."
	appendedSum = 0
	progressCounter = 0
	for i in (stage.start..num)
		appendedSum += 1.0 / i
		if (progressCounter -= 1) <= 0
			progressCounter = 10000
			progress = Float(i - stage.start) / Float(num - stage.start)
			print "Progress: #{(progress*100.0).round}%  \r"
		end
	end
	lowerActual = lower + appendedSum
	upperActual = upper + appendedSum
	puts "\nSum to #{num} = #{lowerActual} to #{upperActual}"
end

print "n= "
number = Integer(gets.chomp)

upperSum = 0
lowerSum = 0
lastStage = nil
loop do
	stage = lastStage.nextStage if lastStage
	stage = SumStage.new(1, 1, 1) if !stage
	if stage.contains? number
		printAnswer(lowerSum, upperSum, lastStage, stage, number)
		break
	end
	lowerSum += stage.lowerLimit
	upperSum += stage.upperLimit
	lastStage = stage
end

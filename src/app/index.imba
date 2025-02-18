import {nanoid} from 'nanoid'

global css body d:vcc inset:0

tag board
	tenzies = []
	pattern = 0
	done = false
	rolls = 0
	oppsies = 0
	
	def setup
		genTenzies()
	
	get score
		rolls * 2 - oppsies

	def hasTrue
		tenzies.some do(item) item.freeze is true

	def samePattern(tenz, e)
		if tenz.num isnt pattern and tenz.freeze is true
			e.target.style.backgroundColor = "red"
			oppsies += 1
		else
			e.target.style.backgroundColor = ""

	def setPattern tenz, e
		tenz.freeze = !tenz.freeze
		if !pattern
			pattern = tenz.num
		samePattern(tenz, e)
		if !hasTrue()
			pattern = 0
		if allGood()
			done = true
			imba.commit()

	def genTenzies
		tenzies = []
		done = false
		pattern = 0
		rolls = 20
		oppsies = 0
		for i in [0...10]
			tenzies.push({num: genNum(), freeze:false, id: nanoid()})

	def genNum
		Math.ceil Math.random() * 10

	def rollDice
		rolls--
		for tenz in tenzies
			if tenz.freeze is false
				tenz.num = genNum()
		if done then genTenzies()

	def allGood
		tenzies.every do(item) item.num is pattern and item.freeze is true

	def render
		<self [d:vcc g:4 pos:relative]>
			if rolls is 0
				<game-over @again=genTenzies pattern=pattern>
			
			if done
				<you-win @again=genTenzies pattern=pattern>
			<div [d:hcs g:5 w:100% ]> 
				<span> "Score: {score}"
				<span> "Rolls: {rolls}"
				<span> "Oppsies: {oppsies}"
				<div [d:hcc g:2]>
					<p> if !pattern then "Select Pattern" else "Pattern:"
					if pattern
						<div [bgc:red4 d:vcc s:40px fs:2xl]> pattern

			<div [d:grid gtc: repeat(5, 1fr) g:2]> for tenz in tenzies
				<button [bgc:red4 s:100px d:vcc fs:4xl bd:1px solid]
					@click=setPattern(tenz, e)
					[bgc:green4]=tenz.freeze
					[bgc:blue4]=done
					# [c:blue2]=(tenz.num is pattern)

				> tenz.num 
			<button [p:4 w:100% bgc:red4 @active:red3 c:cool1 @active:cool8 bd:1px solid] @click=rollDice> if done then "Again" else "Roll Dice"

tag timer
	timer = 60
	<self autorender=1fps>
		<span> if timer > 0 then timer-- else "times up! {timer}"

tag game-over
	<self [d:vcc inset:-5 bgc:gray8 o:95%]>
		<div [fs:6xl c:white]> "Game Over!"
		<p [fs:2xl c:white]> "{pattern} is not your lucky number today 😈."
		<button @click=emit("again") [bgc:red4 @hover:red5 bd:none py:2 px:4 cursor:pointer fs:2xl c:white rd:lg]> "Again"

tag you-win
	<self [d:vcc inset:-5 bgc:blue6 o:95%]>
		<div [fs:6xl c:white]> "You Win!"
		<button @click=emit("again") [bgc:red4 @hover:red5 bd:none py:2 px:4 cursor:pointer fs:2xl c:white rd:lg]> "Again"

tag tenzie-app
	<self>
		<h1 [ta:center]> "Tenzies"
		<board>
		
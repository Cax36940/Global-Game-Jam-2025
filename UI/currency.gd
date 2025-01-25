class_name Currency

var na: int
var cl: int
var h: int
var o: int

func _init(_na, _cl, _h, _o) -> void:
	self.na = _na
	self.cl = _cl
	self.h = _h
	self.o = _o

func add_self(value: Currency) -> void:
	self.na += value.na
	self.cl += value.cl
	self.h += value.h
	self.o += value.o

static func multiply(c: Currency, f: int) -> Currency:
	return Currency.new(c.na*f, c.cl*f, c.h*f, c.o*f)

func multiply_self(f: int) -> void:
	self.na *= f
	self.cl *= f
	self.h *= f
	self.o *= f

func try_substract_self(value: Currency) -> bool:
	var r = 0 
	r = self.na - value.na
	if r < 0: return false	 
	r = self.cl - value.cl
	if r < 0: return false 
	r = self.h - value.h
	if r < 0: return false
	r = self.o - value.o
	if r < 0: return false

	self.na -= value.na
	self.cl -= value.cl
	self.h -= value.h
	self.o -= value.o
	return true


static var costs = {
	"H2": Currency.new(0, 0, 2, 0),
	"O2": Currency.new(0, 0, 0, 2),
	"NaCl": Currency.new(1, 1, 0, 0),
	"NaClO": Currency.new(1, 1, 0, 1),
	"NaClO3": Currency.new(1, 1, 0, 3),
	"NaClO4": Currency.new(1, 1, 0, 4),
	"NaOH": Currency.new(1, 0, 1, 1),
	"HCl": Currency.new(0, 1, 1, 0)
}


static func parse_from_costs(c: Currency) -> String:
	for key in costs:
		if (costs[key].na == 0 and c.na != 0) \
			or (costs[key].cl == 0 and c.cl != 0) \
			or (costs[key].h == 0 and c.h != 0) \
			or (costs[key].o == 0 and c.o != 0):
			continue
		
		var q = -1
		if costs[key].na != 0:
			var r = c.na % costs[key].na
			if r != 0: continue
			q = c.na / costs[key].na
		
		if costs[key].cl != 0:
			var r = c.cl % costs[key].cl
			if r != 0: continue
			var n = c.cl / costs[key].cl
			if q == -1:
				q = n
			elif q != n: continue
		
		if costs[key].h != 0:
			var r = c.h % costs[key].h
			if r != 0: continue
			var n = c.h / costs[key].h
			if q == -1:
				q = n
			elif q != n: continue
		
		if costs[key].o != 0:
			var r = c.o % costs[key].o
			if r != 0: continue
			var n = c.o / costs[key].o
			if q == -1:
				q = n
			elif q != n: continue
		
		return str(q) + " " + key
	return (str(c.na) + " Na+, " if c.na != 0 else "") \
		+ (str(c.cl) + " Cl-, " if c.cl != 0 else "") \
		+ (str(c.h) + " H+, " if c.h != 0 else "") \
		+ (str(c.o) + " O-" if c.o != 0 else "")

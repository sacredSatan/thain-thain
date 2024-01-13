extends RichTextLabel

@export var operand1: int
@export var operand2: int
@export var operator: Constants.SUPPORTED_OPERATORS
@export var selected_operand = 1

var parent
var switch_timer

const CENTERED_TEXT_STRING_START = "[center]"
const CENTERED_TEXT_STRING_END = "[/center]"
const SELECTED_COLOR_STRING_START  = "[color=#FF0000]"
const SELECTED_COLOR_STRING_END  = "[/color]"


var operator_sybmol_map = {
	Constants.SUPPORTED_OPERATORS.MULTIPLICATION: "x",
	Constants.SUPPORTED_OPERATORS.DIVISION: "/",
}



# Called when the node enters the scene tree for the first time.
func _ready():
	if not parent:
		parent = get_parent()
	
#	if not switch_timer:
#		print(" here ")
#		switch_timer = get_node("%MainOperandSwitchTimer")
#		print("swtc ", switch_timer)
	
	if not operand1:
		operand1 = randi_range(10, 18)
	
	if not operand2:
		operand2 = randi_range(1, 13)

	if not operator:
		operator = Constants.SUPPORTED_OPERATORS.values().pick_random()

	draw_label()
#	handle_operand_switch()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# puke
#	global_position = parent.global_position
#	set_rotation_degrees(-parent.get_rotation_degrees())
	pass


func switch_operand(operand_num):
	selected_operand = operand_num
	draw_label()


func handle_operand_switch():
#	if switch_timer:
#		await switch_timer.timeout	
	selected_operand = 1 if selected_operand != 1 else 2
	draw_label()
#	handle_operand_switch()


func draw_label():
	const LABEL_FORMAT_STR = "[center]{pre_op1}{op1}{post_op1} {operator} {pre_op2}{op2}{post_op2}[/center]"

	var pre_op1 = SELECTED_COLOR_STRING_START if selected_operand == 1 else ""
	var post_op1 = SELECTED_COLOR_STRING_END if selected_operand == 1 else ""
	var pre_op2 = SELECTED_COLOR_STRING_START if selected_operand == 2 else ""
	var post_op2 = SELECTED_COLOR_STRING_END if selected_operand == 2 else ""

	var prepared_str = LABEL_FORMAT_STR.format({
		"pre_op1": pre_op1,
		"op1": str(operand1),
		"post_op1": post_op1,
		"operator": operator_sybmol_map[operator],
		"pre_op2": pre_op2,
		"op2": str(operand2),
		"post_op2": post_op2,
	})
	text = prepared_str


func decrement_selected_operand():
	if selected_operand == 1:
		operand1 -= 1
	else:
		operand2 -= 1

	draw_or_die()


func increment_selected_operand():
	if selected_operand == 1:
		operand1 += 1
	else:
		operand2 += 1

	draw_or_die()


func draw_or_die():
	var operation_value = evaluate_operation()
	if operation_value < 1:
		var parent = get_parent()
		if "handle_equation_death" in parent:
			parent.handle_equation_death()
	else:
		draw_label()


func evaluate_operation():
	var value = 0
	if operator == Constants.SUPPORTED_OPERATORS.DIVISION:
		value = operand1 / operand2 if operand2 > 0 else 0.9
	elif operator == Constants.SUPPORTED_OPERATORS.MULTIPLICATION:
		value = operand1 * operand2
		
	return value

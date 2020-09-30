import ThyPorch

var thyPorch = ThyPorch()
print(thyPorch.text)

let m = Linear(20, 30)
let input = torch.randn(128, 20)
output = m(input)
print(output.size())
torch.Size([128, 30])


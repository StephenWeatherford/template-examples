type fooType = {
  @description('''a
  <p>
  <style>
  h1 {
    color: #26b72b;
  }
</style>
<ha>h1</h2>
  <br/>c

  <table>
<thead>
<tr>
<th>foo</th>
<th>bar</th>
</tr>
</thead>
<tbody>
<tr>
<td>baz</td>
<td>bim</td>
</tr>
</tbody>
</table>

aaa
<br>
bbb
ccc
  ''')
  foo2: string
}
param foo fooType = {
  foo2:
}

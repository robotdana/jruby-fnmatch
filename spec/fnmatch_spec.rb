RSpec.describe 'fnmatch' do
  it 'works with literal values' do
    expect(::File.fnmatch?('aaa', 'aaa')).to be true
    expect(::File.fnmatch?('aaa', 'a/a')).to be false
    expect(::File.fnmatch?('aaa', 'aba')).to be false
  end

  it 'works with single value square brackets' do
    expect(::File.fnmatch?('a[a]a', 'aaa')).to be true
    expect(::File.fnmatch?('a[a]a', 'a[a]a')).to be false
    expect(::File.fnmatch?('a[a]a', 'aba')).to be false
  end

  it 'works with multiple value square brackets' do
    expect(::File.fnmatch?('a[ab]a', 'aaa')).to be true
    expect(::File.fnmatch?('a[ab]a', 'aba')).to be true
    expect(::File.fnmatch?('a[ab]a', 'a[ab]a')).to be false
  end

  it 'matches / in square brackets when there are other values' do
    expect(::File.fnmatch?('a[a/]a', 'aaa')).to be true
    expect(::File.fnmatch?('a[a/]a', 'aa')).to be false
    expect(::File.fnmatch?('a[a/]a', 'a/a')).to be true
    expect(::File.fnmatch?('a[a/]a', 'aba')).to be false
  end

  it "matches / in square brackets when there are other values and it's the first value" do
    expect(::File.fnmatch?('a[/a]a', 'aaa')).to be true
    expect(::File.fnmatch?('a[/a]a', 'aa')).to be false
    expect(::File.fnmatch?('a[/a]a', 'a/a')).to be true
    expect(::File.fnmatch?('a[/a]a', 'aba')).to be false
  end

  it "matches / in square brackets when it's alone" do
    expect(::File.fnmatch?('a[/]a', 'a/a')).to be true
    expect(::File.fnmatch?('a[/]a', 'a//a')).to be false
    expect(::File.fnmatch?('a[/]a', 'aa')).to be false
  end

  it 'matches / with *' do
    expect(::File.fnmatch?('a*a', 'a/a')).to be true
    expect(::File.fnmatch?('a*a', 'a//a')).to be true
    expect(::File.fnmatch?('a*a', 'aba')).to be true
    expect(::File.fnmatch?('a*a', 'abba')).to be true
    expect(::File.fnmatch?('a*a', 'aa')).to be true
  end

  it 'matches / with ?' do
    expect(::File.fnmatch?('a?a', 'a/a')).to be true
    expect(::File.fnmatch?('a?a', 'a//a')).to be false
    expect(::File.fnmatch?('a?a', 'aba')).to be true
    expect(::File.fnmatch?('a?a', 'abba')).to be false
    expect(::File.fnmatch?('a?a', 'aa')).to be false
  end

  context 'with File::FNM_PATHNAME' do
    it "doesn't match / in square brackets when there are other values aaa" do
      expect(::File.fnmatch?('a[a/]a', 'aaa', ::File::FNM_PATHNAME)).to be true
    end

    it "doesn't match / in square brackets when there are other values aa" do
      expect(::File.fnmatch?('a[/a]a', 'aa', ::File::FNM_PATHNAME)).to be false
    end

    it "doesn't match / in square brackets when there are other values a/a" do
      expect(::File.fnmatch?('a[a/]a', 'a/a', ::File::FNM_PATHNAME)).to be false
    end

    it "doesn't match / in square brackets when there are other values aba" do
      expect(::File.fnmatch?('a[a/]a', 'aba', ::File::FNM_PATHNAME)).to be false
    end

    it "doesn't match / in square brackets when there are other values and it's the first value aaa" do
      expect(::File.fnmatch?('a[/a]a', 'aaa', ::File::FNM_PATHNAME)).to be true
    end

    it "doesn't match / in square brackets when there are other values and it's the first value aa" do
      expect(::File.fnmatch?('a[/a]a', 'aa', ::File::FNM_PATHNAME)).to be false
    end

    it "doesn't match / in square brackets when there are other values and it's the first value a/a" do
      expect(::File.fnmatch?('a[/a]a', 'a/a', ::File::FNM_PATHNAME)).to be false
    end

    it "doesn't match / in square brackets when there are other values and it's the first value aba" do
      expect(::File.fnmatch?('a[/a]a', 'aba', ::File::FNM_PATHNAME)).to be false
    end

    it "doesn't match / in square brackets when it's alone" do
      expect(::File.fnmatch?('a[/]a', 'a/a', ::File::FNM_PATHNAME)).to be false
      expect(::File.fnmatch?('a[/]a', 'a//a', ::File::FNM_PATHNAME)).to be false
      expect(::File.fnmatch?('a[/]a', 'aa', ::File::FNM_PATHNAME)).to be false
    end

    it "doesn't match / with *" do
      expect(::File.fnmatch?('a*a', 'a/a', ::File::FNM_PATHNAME)).to be false
      expect(::File.fnmatch?('a*a', 'a//a', ::File::FNM_PATHNAME)).to be false
      expect(::File.fnmatch?('a*a', 'aba', ::File::FNM_PATHNAME)).to be true
      expect(::File.fnmatch?('a*a', 'abba', ::File::FNM_PATHNAME)).to be true
      expect(::File.fnmatch?('a*a', 'aa', ::File::FNM_PATHNAME)).to be true
    end

    it "doesn't match / with ?" do
      expect(::File.fnmatch?('a?a', 'a/a', ::File::FNM_PATHNAME)).to be false
      expect(::File.fnmatch?('a?a', 'a//a', ::File::FNM_PATHNAME)).to be false
      expect(::File.fnmatch?('a?a', 'aba', ::File::FNM_PATHNAME)).to be true
      expect(::File.fnmatch?('a?a', 'abba', ::File::FNM_PATHNAME)).to be false
      expect(::File.fnmatch?('a?a', 'aa', ::File::FNM_PATHNAME)).to be false
    end
  end

  it "can escape only the first [" do
    expect(::File.fnmatch?('a\[b]a', 'a[b]a')).to be true
    expect(::File.fnmatch?('a\[b]a', 'aba')).to be false
  end

  it "can escape the both []" do
    expect(::File.fnmatch?('a\[b\]a', 'a[b]a')).to be true
    expect(::File.fnmatch?('a\[b\]a', 'aba')).to be false
  end
end

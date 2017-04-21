require 'spec_helper'
require 'webrick'
require 'ampize'

describe Ampize::Ampize do
  before :all do
    require 'webrick'
    @server_thread = Thread.new do
      srv = WEBrick::HTTPServer.new({
        DocumentRoot: './',
        Port: 10021,
        StartCallback: Proc.new { Thread.main.wakeup } 
      })
      Signal.trap(:INT) { srv.shutdown }
      srv.start
    end
    Thread.stop
  end

  after :all do
    Process.kill(:INT, Process.pid)
    @server_thread.join
  end

  it 'has a version number' do
    expect(Ampize::VERSION).not_to be nil
  end

  it 'transforms img to amp-img' do
    ampize = Ampize::Ampize.new()
    r = ampize.transform('<img src="./spec/data/rect.jpg" />')
    expect(r).to eq '<amp-img src="./spec/data/rect.jpg" width="100" height="100" layout="responsive"></amp-img>'
  end

  it 'keeps size attributes' do
    ampize = Ampize::Ampize.new()
    r = ampize.transform('<img src="./spec/data/rect.jpg" width="50" height="50" />')
    expect(r).to eq '<amp-img src="./spec/data/rect.jpg" width="50" height="50" layout="responsive"></amp-img>'
  end

  it 'replace message whenc failed to fetch image.' do
    ampize = Ampize::Ampize.new()
    r = ampize.transform('<img src="notexists.jpg"/>')
    expect(r).to eq %q|'notexists.jpg' is not found.|
  end

  it 'can specify layout' do
    ampize = Ampize::Ampize.new({image_layout:'fixed'})
    r = ampize.transform('<img src="./spec/data/rect.jpg" width="50" height="50" />')
    expect(r).to eq '<amp-img src="./spec/data/rect.jpg" width="50" height="50" layout="fixed"></amp-img>'
  end

  it 'removes style attributes' do
    ampize = Ampize::Ampize.new()
    r = ampize.transform('<p style="color:red;">text</p>')
    expect(r).to eq '<p>text</p>'
  end

  it 'removes these tags: script,frame,frameset,object,param,applet,embed' do
    ampize = Ampize::Ampize.new()
    r = ampize.transform('<script></script><frame></frame><frameset></frameset><object></object><param></param><applet></applet><embed></embed>')
    expect(r).to eq ''
  end

  it 'removes "javascript:" in href attribute of anchor tag' do
    ampize = Ampize::Ampize.new()
    r = ampize.transform('<a href="javascript:alert(a);">hoge</a>')
    expect(r).to eq '<a>hoge</a>'
  end

  it 'removes event attributes such as onclick, onchange' do
    ampize = Ampize::Ampize.new()
    r = ampize.transform('<a onclick="" onchange="">hoge</a>')
    expect(r).to eq '<a>hoge</a>'
  end
end


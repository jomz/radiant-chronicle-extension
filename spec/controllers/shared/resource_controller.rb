shared_examples_for "versioned resource controller" do
  
  it { controller.should respond_to(:load_model_with_version) }
  
  it { controller.should respond_to(:load_model_without_version) }
  
  it "should return the current version of a versioned resource" do
    @mock_resource = mock('resource')
    @mock_resource.should_receive(:current).and_return(@mock_resource)
    @mock_resource.should_receive(:respond_to?).with(:current).and_return(true)
    @mock_resource.should_receive(:respond_to?).with(:versions).and_return(true)
    controller.should_receive(:load_model_without_version).and_return(@mock_resource)
    controller.stub!(:action_name).and_return('edit')
    controller.load_model_with_version.should == @mock_resource
  end
end
